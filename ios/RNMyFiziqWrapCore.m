
#import "RNMyFiziqWrapCore.h"
#import "RNMyFiziqWrapCommon.h"

@implementation RNMyFiziqWrapCore

+ (instancetype)shared {
    static RNMyFiziqWrapCore *mfzCore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mfzCore = [[RNMyFiziqWrapCore alloc] init];
    });
    return mfzCore;
}

- (void)mfzSdkStatusConnectionResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve(@([MyFiziqSDK shared].statusConnection));
}

- (void)mfzSdkStatusVersionResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve(@([MyFiziqSDK shared].statusVersion));
}

- (void)mfzSdkAppIdResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve([MyFiziqSDK shared].appId);
}

- (void)mfzSdkVendorIdResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve([MyFiziqSDK shared].vendorId);
}

- (void)mfzSdkClientIdResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve([MyFiziqSDK shared].clientId);
}

- (void)mfzSdkEnvResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve([MyFiziqSDK shared].env);
}

- (void)mfzSdkUserPoolIdResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve([MyFiziqSDK shared].cognitoUserPoolId);
}

- (void)mfzSdkUserPoolRegionResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve([MyFiziqSDK shared].cognitoUserPoolRegion);
}

- (void)mfzSdkUserPoolLoginsKeyResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve([MyFiziqSDK shared].cognitoUserPoolLoginsKey);
}

- (void)mfzSdkLoadCSSPath:(NSString *)cssPath resolver:(RCTPromiseResolveBlock)resolve {
    if (cssPath) [RNMyFiziqWrapCommon shared].sdkCssPathLocal = cssPath;
    if (resolve) resolve(nil);
}

@end
