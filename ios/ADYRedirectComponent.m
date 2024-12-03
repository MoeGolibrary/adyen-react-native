//
// Copyright (c) 2023 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "ADYRedirectComponent.h"
#if __has_include("AdyenReactNative-Swift.h")
#import "AdyenReactNative-Swift.h"
#else
#import "AdyenReactNative/AdyenReactNative-Swift.h"
#endif

@implementation ADYRedirectComponent

+ (BOOL)applicationDidOpenURL:(nonnull NSURL *)url {
    return [RedirectComponentProxy proccessURL: url];
}

@end
