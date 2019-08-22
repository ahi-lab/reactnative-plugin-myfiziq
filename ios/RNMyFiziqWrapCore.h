
#import <React/RCTBridgeModule.h>
#import <MyFiziqSDK/MyFiziqSDK.h>

@interface RNMyFiziqWrapCore : NSObject
@property (strong, nonatomic) NSDictionary<NSString *, NSString *> *setupConfig;
@property (strong, nonatomic) AWSTaskCompletionSource<NSDictionary *> *authTokens;
+ (instancetype)shared;
- (void)mfzSdkStatusConnectionResolver:(RCTPromiseResolveBlock)resolve;
- (void)mfzSdkStatusVersionResolver:(RCTPromiseResolveBlock)resolve;
- (void)mfzSdkAppIdResolver:(RCTPromiseResolveBlock)resolve;
- (void)mfzSdkVendorIdResolver:(RCTPromiseResolveBlock)resolve;
- (void)mfzSdkClientIdResolver:(RCTPromiseResolveBlock)resolve;
- (void)mfzSdkEnvResolver:(RCTPromiseResolveBlock)resolve;
- (void)mfzSdkUserPoolIdResolver:(RCTPromiseResolveBlock)resolve;
- (void)mfzSdkUserPoolRegionResolver:(RCTPromiseResolveBlock)resolve;
- (void)mfzSdkUserPoolLoginsKeyResolver:(RCTPromiseResolveBlock)resolve;
- (void)mfzSdkLoadCSSPath:(NSString *)cssPath resolver:(RCTPromiseResolveBlock)resolve;
@end
