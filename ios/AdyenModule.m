//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//


#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(AdyenDropIn, NSObject)

RCT_EXTERN_METHOD(open:(nonnull NSDictionary *)paymentMethods
                  configuration:(nonnull NSDictionary *)configuration)

RCT_EXTERN_METHOD(hide:(nonnull NSNumber *)success
                  event:(nullable NSDictionary *)event)

RCT_EXTERN_METHOD(handle:(nonnull NSDictionary *)action)

RCT_EXTERN_METHOD(getReturnURL:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(update:(nullable NSArray *)results)

RCT_EXTERN_METHOD(confirm:(nonnull NSNumber *)success
                  address:(nonnull NSDictionary *)address)

RCT_EXTERN_METHOD(removeStored:(nonnull NSNumber *)success)

@end

@interface RCT_EXTERN_MODULE(AdyenInstant, NSObject)

RCT_EXTERN_METHOD(open:(NSDictionary *)paymentMethods
                  configuration:(NSDictionary *)configuration)

RCT_EXTERN_METHOD(hide:(nonnull NSNumber *)success
                  event:(NSDictionary *)event)

RCT_EXTERN_METHOD(handle:(NSDictionary *)action)

@end

@interface RCT_EXTERN_MODULE(AdyenApplePay, NSObject)

RCT_EXTERN_METHOD(open:(NSDictionary *)paymentMethods
                  configuration:(NSDictionary *)configuration)

RCT_EXTERN_METHOD(hide:(nonnull NSNumber *)success
                  event:(NSDictionary *)event)

@end

// Mock to prevent NativeModule check failure
@interface RCT_EXTERN_MODULE(AdyenGooglePay, NSObject)

RCT_EXTERN_METHOD(open:(NSDictionary *)paymentMethods
                  configuration:(NSDictionary *)configuration)

@end

@interface RCT_EXTERN_MODULE(AdyenCSE, NSObject)

RCT_EXTERN_METHOD(encryptCard:(NSDictionary *)card
                  publicKey:(NSString *)publicKey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(encryptBin:(NSString *)bin
                  publicKey:(NSString *)publicKey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end

@interface RCT_EXTERN_MODULE(SessionHelper, NSObject)

RCT_EXTERN_METHOD(createSession:(NSDictionary *)sessionModelJSON
                  configuration:(NSDictionary *)configurationJSON
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(hide:(nonnull NSNumber *)success
                  event:(NSDictionary *)event)

@end

@interface RCT_EXTERN_MODULE(AdyenAction, NSObject)

RCT_EXTERN_METHOD(hide:(nonnull NSNumber *)success)

RCT_EXTERN_METHOD(handle:(NSDictionary *)action
                  configuration:(NSDictionary *)configurationJSON
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end


@interface RCT_EXTERN_MODULE(AdyenCardView, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(config, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onHeightChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onDataChange, RCTBubblingEventBlock)

@end

@interface RCT_EXTERN_MODULE(AdyenTerminal, NSObject)

RCT_EXTERN_METHOD(startDiscovery)
RCT_EXTERN_METHOD(stopDiscovery)

RCT_EXTERN_METHOD(connectTo:(NSDictionary *)device)
RCT_EXTERN_METHOD(disconnect)

RCT_EXTERN_METHOD(startFirmwareUpdate)

RCT_EXTERN_METHOD(pay:(NSNumber *)type
                  requestData:(NSString *)requestData)

RCT_EXTERN_METHOD(setSdkData:(NSString *)callbackId value:(NSString *)value)

@end
