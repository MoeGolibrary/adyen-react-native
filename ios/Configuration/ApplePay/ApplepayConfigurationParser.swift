//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Adyen
import PassKit

public struct ApplepayConfigurationParser {

    private var dict: [String: Any]

    public init(configuration: NSDictionary) {
        guard let configuration = configuration as? [String: Any] else {
            self.dict = [:]
            return
        }
        if let configurationNode = configuration[ApplePayKeys.rootKey] as? [String: Any] {
            self.dict = configurationNode
        } else {
            self.dict = configuration
        }
    }

    var merchantID: String? {
        dict[ApplePayKeys.merchantID] as? String
    }

    var merchantName: String? {
        dict[ApplePayKeys.merchantName] as? String
    }

    var allowOnboarding: Bool {
        if let bool = dict[ApplePayKeys.allowOnboarding] as? Bool {
            return bool
        }
        if let string = dict[ApplePayKeys.allowOnboarding] as? String {
            return string.lowercased() == "true"
        }
        if let number = dict[ApplePayKeys.allowOnboarding] as? NSNumber {
            return number.boolValue
        }
        return false
    }

    var requiredShippingContactFields: Set<PKContactField> {
        guard let requiredFields = dict[ApplePayKeys.requiredShippingContactFields] as? [String] else {
            return []
        }
        return Set<PKContactField>(requiredFields.compactMap { PKContactField.fromString($0) })
    }

    var requiredBillingContactFields: Set<PKContactField> {
        guard let requiredFields = dict[ApplePayKeys.requiredBillingContactFields] as? [String] else {
            return []
        }
        return Set<PKContactField>(requiredFields.compactMap { PKContactField.fromString($0) })
    }

    var billingContact: PKContact? {
        guard let dictionary = dict[ApplePayKeys.billingContact] as? [String: Any] else {
            return nil
        }

        return PKContact(dictionary)
    }

    var shippingContact: PKContact? {
        guard let dictionary = dict[ApplePayKeys.shippingContact] as? [String: Any] else {
            return nil
        }

        return PKContact(dictionary)
    }

    var summaryItems: [PKPaymentSummaryItem]? {
        guard let items = dict[ApplePayKeys.summaryItems] as? [[String: Any]] else {
            return nil
        }

        let summaryItems = items.compactMap(PKPaymentSummaryItem.init)
        return summaryItems.isEmpty ? nil : summaryItems
    }

    var shippingType: PKShippingType? {
        guard let type = dict[ApplePayKeys.shippingType] as? String else { return nil }
        return ApplePayShippingType(rawValue: type)?.toAppleType
    }

    var supportedCountries: Set<String>? {
        guard let items = dict[ApplePayKeys.supportedCountries] as? [String] else {
            return nil
        }
        return .init(items)
    }

    var shippingMethods: [PKShippingMethod]? {
        guard let items = dict[ApplePayKeys.shippingMethods] as? [[String: Any]] else {
            return nil
        }

        let shippingMethods = items.compactMap(PKShippingMethod.initiate)
        return shippingMethods.isEmpty ? nil : shippingMethods
    }

    @available(iOS 16.0, *)
    var recurringPaymentRequest: PKRecurringPaymentRequest? {
        guard let recurringDict = dict[ApplePayKeys.recurringPaymentRequest] as? NSDictionary else {
            return nil
        }

        let parser = ApplePayRecurringConfigurationParser(configuration: recurringDict)
        return parser.paymentRequest
    }

    public func buildConfiguration(payment: Payment) throws -> Adyen.ApplePayComponent.Configuration {
        let paymentRequest = try buildPaymentRequest(payment: payment)
        return try .init(paymentRequest: paymentRequest, allowOnboarding: allowOnboarding)
    }

    internal func buildPaymentRequest(payment: Payment) throws -> PKPaymentRequest {
        guard let merchantID else {
            throw ApplePayError.invalidMerchantID
        }

        let summaryItems: [PKPaymentSummaryItem]
        if let summaryItemsFromConfig = self.summaryItems {
            summaryItems = summaryItemsFromConfig
        } else {
            guard let merchantName else {
                throw ApplePayError.invalidMerchantName
            }

            let amount = AmountFormatter.decimalAmount(payment.amount.value,
                                                       currencyCode: payment.amount.currencyCode,
                                                       localeIdentifier: payment.amount.localeIdentifier)
            summaryItems = [PKPaymentSummaryItem(label: merchantName, amount: amount)]
        }

        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = merchantID
        paymentRequest.paymentSummaryItems = summaryItems
        paymentRequest.countryCode = payment.countryCode
        paymentRequest.currencyCode = payment.amount.currencyCode
        paymentRequest.billingContact = billingContact
        paymentRequest.requiredShippingContactFields = requiredShippingContactFields
        paymentRequest.requiredBillingContactFields = requiredBillingContactFields
        paymentRequest.merchantCapabilities = [.capability3DS]
        paymentRequest.shippingContact = shippingContact
        paymentRequest.shippingType = shippingType ?? .shipping
        paymentRequest.supportedCountries = supportedCountries
        paymentRequest.shippingMethods = shippingMethods

        if #available(iOS 16.0, *), let recurringPaymentRequest {
            paymentRequest.recurringPaymentRequest = recurringPaymentRequest
        }

        return paymentRequest
    }
}

extension ApplepayConfigurationParser {

    public enum ApplePayError: String, LocalizedError, KnownError {
        case invalidMerchantName
        case invalidMerchantID

        var errorCode: String {
            self.rawValue
        }

        public var errorDescription: String? {
            switch self {
            case .invalidMerchantName:
                return "Neither `summaryItems` nor `merchantName` in Apple Pay configuration"
            case .invalidMerchantID:
                return "No Apple Pay merchantID in configuration"
            }
        }
    }
}
