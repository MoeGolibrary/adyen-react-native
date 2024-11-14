//
//  CardViewManager.swift
//  adyen-react-native
//
//  Created by wangcheng on 2024/11/10.
//

import UIKit
import React
@_spi(AdyenInternal) import Adyen

//private let panThrottler = Throttler(minimumDelay: 0.5)

// RN使用flexbox布局，sdk使用autolayout布局，为了高度显示正常，改为手动计算高度。
private let itemHeight = 63.0
private let errorLabelHeight = 23.0

class CustomCardView: UIView {
    
    @objc var config: NSDictionary?
    @objc var onHeightChange: RCTBubblingEventBlock?
    @objc var onDataChange: RCTBubblingEventBlock?
    
    @objc var didMoveToSuperviewBlock: (() ->())?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        onHeightChange?(["height": itemHeight * 2])
        
        didMoveToSuperviewBlock?()
    }
}


@objc(AdyenCardView)
internal final class CardViewManager: RCTViewManager {
    @objc var onDataChange: RCTBubblingEventBlock?
    
    private lazy var cardView: CustomCardView = {
        let cardView = CustomCardView()
        cardView.didMoveToSuperviewBlock = { [weak self] in
            self?.addCardView()
        }
        return cardView
    }()
    
    override func view() -> UIView! {
        return cardView
    }
    
    override class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    private func addCardView() {
        cardView.addSubview(cardViewController.view)
        cardViewController.view.translatesAutoresizingMaskIntoConstraints = false
        cardViewController.view.widthAnchor.constraint(equalTo: cardView.widthAnchor).isActive = true
        cardViewController.view.heightAnchor.constraint(equalTo: cardView.heightAnchor).isActive = true
    }
    
    lazy var cardViewController: CardViewController = {
        let props = cardView.config ?? [:]
        
        let baseURL = props.object(forKey: "baseURL") as? String ?? ""
        let clientKey = props.object(forKey: "clientKey") as? String ?? ""
        let countryCode = props.object(forKey: "countryCode") as? String ?? "US"
        
        
        let configuration = generateConfig()
        let apiContext = try! APIContext(environment: Environment(baseURL: URL(string:baseURL)!), clientKey: clientKey)
        
        let formViewController = CardViewController(
            configuration: configuration,
            shopperInformation: configuration.shopperInformation,
            formStyle: configuration.style,
            payment: nil,
            logoProvider: LogoURLProvider(environment: apiContext.environment),
            supportedCardTypes: [.masterCard, .visa, .maestro],
            initialCountryCode: countryCode,
            scope: String(describing: self),
            localizationParameters: configuration.localizationParameters
        )
        
        formViewController.items.onDidTriggerInfoEvent = { [weak self] event in
            if event.type == .unfocus {
                self?.cardContentChanged()
            }
        }
        
        return formViewController
    }()
    
    private func generateConfig() -> CardComponent.Configuration {
        let style = FormComponentStyle()
        var configuration = CardComponent.Configuration(style: style)
        configuration.showsSubmitButton = false
        configuration.showsSupportedCardLogos = false
        configuration.showsStorePaymentMethodField = false
        configuration.style.backgroundColor = .clear
        
        return configuration
    }
}


extension CardViewManager {
    private func cardContentChanged() {
        cardViewController.showValidation()
        
        let numberItem = cardViewController.items.numberContainerItem.numberItem
        let expiryDateItem = cardViewController.items.expiryDateItem
        let securityCodeItem = cardViewController.items.securityCodeItem
        
        let isNumberValid = numberItem.isValid()
        let isExpiryDateValid = expiryDateItem.isValid()
        let isSecurityCodeValid = securityCodeItem.isValid()
        
        let number = numberItem.value
        let expiryMonth = expiryDateItem.expiryMonth ?? ""
        let expiryYear = expiryDateItem.expiryYear ?? ""
        let securityCode = securityCodeItem.value
        
        var cardHeight = itemHeight * 2
        if !isNumberValid {
            cardHeight += errorLabelHeight
        }
        if !isExpiryDateValid || !isSecurityCodeValid {
            cardHeight += errorLabelHeight
        }
        
        cardView.onHeightChange?(["height": cardHeight])
        
        cardView.onDataChange?([
            "isValid": isNumberValid && isExpiryDateValid && isSecurityCodeValid,
            "data": [
                "number": number,
                "expiryMonth": expiryMonth,
                "expiryYear": expiryYear,
                "securityCode": securityCode,
            ]
        ])
    }
}
