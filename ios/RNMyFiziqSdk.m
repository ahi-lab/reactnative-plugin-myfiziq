
#import "RNMyFiziqSdk.h"
#import <React/RCTLog.h>
#import <MyFiziqSDK/MyFiziqSDK.h>
#import "RNMyFiziqWrapCore.h"
#import "RNMyFiziqWrapUser.h"
#import "RNMyFiziqWrapAvatar.h"
#import "RNMyFiziqWrapCognitoAuth.h"

/*
 * This class is the RN facing interface. It should just be a proxy that invokes the native interfaces (such as SDK and bespoke view controllers).
 * RNMyFiziqSdk is based on MyFiziqSDK Cordova plugin, as there are similarities with the interface structure. All methods return via async.
 */

@interface RNMyFiziqSdk() <MyFiziqSDKDelegate>
@end

@implementation RNMyFiziqSdk

RCT_EXPORT_MODULE();

+ (id)allocWithZone:(struct _NSZone *)zone {
  static RNMyFiziqSdk *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}

+ (id)alloc {
  return [RNMyFiziqSdk allocWithZone:nil];
}

- (NSArray<NSString *> *)supportedEvents {
  return @[RNMFZCORE_EVENT_AUTH];
}

#pragma mark - RN Export Core

RCT_REMAP_METHOD(mfzSdkSetup,
                 key:(NSString *)key
                 secret:(NSString *)secret
                 environment:(NSString *)env
                 mfzSdkSetupWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    RCTLogInfo(@"MFZ: mfzSdkSetup called");
    // Check params
    if (!key || !secret || !env) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCoreErrorSetupParamNil],
                           RNMFZCORE_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZCORE_ERR_DOMAIN code:RNMFZCoreErrorSetupParamNil userInfo:nil]);
    }
    // Call setup
    RNMyFiziqWrapCore *core = [RNMyFiziqWrapCore shared];
    core.setupConfig = @{MFZSdkSetupKey:key, MFZSdkSetupSecret:secret, MFZSdkSetupEnvironment:env};
    [[MyFiziqSDK shared] setupWithConfig:core.setupConfig authDelegate:self success:^(NSDictionary * _Nonnull status) {
        RCTLogInfo(@"MFZ: MyFiziqSDK setup success");
        if (resolve) resolve(nil);
    } failure:^(NSError * _Nonnull error) {
        RCTLogError(@"MFZ ERR: %@",error.localizedDescription);
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCoreErrorSetupFailed],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZCORE_ERR_DOMAIN code:RNMFZCoreErrorSetupFailed userInfo:@{NSLocalizedDescriptionKey:@(error.code)}]);
    }];
}

// AWS service calls this when authentication token is required. This invokes event 'myfiziqGetAuthToken', which
// indirectly invokes plugin 'logins' with the auth token set.
- (AWSTask<NSDictionary<NSString *, NSString *> *> *)logins {
    RNMyFiziqWrapCore *core = [RNMyFiziqWrapCore shared];
    core.authTokens = [[AWSTaskCompletionSource<NSDictionary *> alloc] init];
    RNMyFiziqSdk *myself = [RNMyFiziqSdk alloc];
    [myself sendEventWithName:RNMFZCORE_EVENT_AUTH body:@"ignore"];
    return [AWSTask taskForCompletionOfAnyTask:@[core.authTokens.task]];
}

- (void)reloadMyFiziqSDK {
    // Reload using config
    RNMyFiziqWrapCore *core = [RNMyFiziqWrapCore shared];
    if (core.setupConfig) {
        [[MyFiziqSDK shared] setupWithConfig:core.setupConfig authDelegate:self success:^(NSDictionary * _Nonnull status) {
            RCTLogInfo(@"MFZ: MyFiziqSDK reload success");
        } failure:^(NSError * _Nonnull error) {
            RCTLogError(@"MFZ ERR: %@",error.localizedDescription);
        }];
    }
}

// On RN code invoking from 'myfiziqGetAuthToken' event, the RN must answer the request with the idp key and token by
// calling this method 'mfzSdkAnswerLogins'.
RCT_REMAP_METHOD(mfzSdkAnswerLogins,
                 key:(NSString *)idpKey
                 token:(NSString *)idpToken
                 mfzSdkAnswerLoginsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    RNMyFiziqWrapCore *core = [RNMyFiziqWrapCore shared];
    // Check params
    if (!idpKey || !idpToken) {
        [core.authTokens trySetResult:nil];
        if (resolve) resolve(nil);
    } else {
        // Answer the call
        NSDictionary<NSString *, NSString *> *tokenAnswer = @{idpKey:idpToken};
        [core.authTokens trySetResult:tokenAnswer];
        if (resolve) resolve(nil);
    }
}

RCT_REMAP_METHOD(mfzSdkInitiateAvatarCreation,
                 mfzSdkInitiateAvatarCreationWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    RCTLogInfo(@"MFZ: mfzSdkInitiateAvatarCreation called");
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    [[MyFiziqSDK shared] initiateAvatarCreationWithOptions:nil withMiscellaneousData:nil fromViewController:vc completion:^(NSError * _Nullable err) {
        RCTLogInfo(@"MFZ: mfzSdkInitiateAvatarCreation completed");
        if (err && err.code != MFZSdkErrorCodeCancelCreation && err.code != MFZSdkErrorCodeOKCaptureCancel) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZCORE_ERR_DOMAIN code:RNMFZCoreErrorCaptureProcessFailed userInfo:@{NSLocalizedDescriptionKey:@(err.code)}]);
        } else {
            // Resolve with potential user cancel
            if (resolve) resolve(err.code == MFZSdkErrorCodeCancelCreation || err.code == MFZSdkErrorCodeOKCaptureCancel ? @"cancel" : nil);
        }
    }];
}

#pragma mark - RN Export Core Properties

RCT_REMAP_METHOD(mfzSdkStatusConnection,
                 mfzSdkStatusConnectionWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCore shared] mfzSdkStatusConnectionResolver:resolve];
}

RCT_REMAP_METHOD(mfzSdkStatusVersion,
                 mfzSdkStatusVersionWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCore shared] mfzSdkStatusVersionResolver:resolve];
}

RCT_REMAP_METHOD(mfzSdkAppId,
                 mfzSdkAppIdWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCore shared] mfzSdkAppIdResolver:resolve];
}

RCT_REMAP_METHOD(mfzSdkVendorId,
                 mfzSdkVendorIdWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCore shared] mfzSdkVendorIdResolver:resolve];
}

RCT_REMAP_METHOD(mfzSdkClientId,
                 mfzSdkClientIdWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCore shared] mfzSdkClientIdResolver:resolve];
}

RCT_REMAP_METHOD(mfzSdkEnv,
                 mfzSdkEnvWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCore shared] mfzSdkEnvResolver:resolve];
}

RCT_REMAP_METHOD(mfzSdkCognitoUserPoolId,
                 mfzSdkCognitoUserPoolIdWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCore shared] mfzSdkUserPoolIdResolver:resolve];
}

RCT_REMAP_METHOD(mfzSdkCognitoUserPoolRegion,
                 mfzSdkCognitoUserPoolRegionWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCore shared] mfzSdkUserPoolRegionResolver:resolve];
}

RCT_REMAP_METHOD(mfzSdkCognitoUserPoolLoginsKey,
                 mfzSdkCognitoUserPoolLoginsKeyWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCore shared] mfzSdkUserPoolLoginsKeyResolver:resolve];
}

#pragma mark - RN Export Style

RCT_REMAP_METHOD(mfzSdkLoadCSS,
                 path:(NSString *)cssPath
                 mfzSdkLoadCSSWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCore shared] mfzSdkLoadCSSPath:cssPath resolver:resolve];
}

#pragma mark - RN Export Cognito User Pool Auth

RCT_REMAP_METHOD(mfzCognitoUserSignedIn,
                 mfzCognitoUserSignedInWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCognitoAuth shared] mfzCognitoUserSignedInResolver:resolve];
}

RCT_REMAP_METHOD(mfzCognitoUserValidateInput,
                 email:(NSString *)email
                 passwordA:(NSString *)passA
                 passwordB:(NSString *)passB
                 mfzCognitoUserValidateInputWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCognitoAuth shared] mfzCognitoUserValidateInputEmail:email passA:passA passB:passB resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzCognitoUserLogin,
                 email:(NSString *)email
                 password:(NSString *)pass
                 mfzCognitoUserLoginWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCognitoAuth shared] mfzCognitoUserLoginEmail:email password:pass resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzCognitoUserPasswordResetRequest,
                 email:(NSString *)email
                 mfzCognitoUserPasswordResetRequestWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCognitoAuth shared] mfzCognitoUserPasswordResetRequestEmail:email resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzCognitoUserPasswordResetConfirm,
                 email:(NSString *)email
                 resetCode:(NSString *)rcode
                 newPassword:(NSString *)newPass
                 mfzCognitoUserPasswordResetConfirmWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCognitoAuth shared] mfzCognitoUserPasswordResetConfirmEmail:email resetCode:rcode newPassword:newPass resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzCognitoUserLogout,
                 mfzCognitoUserLogoutWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCognitoAuth shared] mfzCognitoUserLogoutResolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzCognitoUserToken,
                 mfzCognitoUserTokenWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [[RNMyFiziqWrapCognitoAuth shared] mfzCognitoUserTokenResolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzCognitoUserReauthenticate,
                 mfzCognitoUserReauthenticateWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  [[RNMyFiziqWrapCognitoAuth shared] mfzCognitoUserReauthenticateResolver:resolve rejecter:reject];
}

#pragma mark - RN Export User

RCT_REMAP_METHOD(mfzUserRegister,
                 optionalEmail:(NSString *)email
                 mfzUserRegisterWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserRegisterEmail:email Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzUserLogin,
                 optionalEmail:(NSString *)email
                 mfzUserLoginWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserLoginEmail:email Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzUserLogout,
                 mfzUserLogoutWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserLogoutResolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzUserUpdateDetails,
                 mfzUserUpdateDetailsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserUpdateDetailsResolver:resolve rejecter:reject];
}

#pragma mark - RN Export User Properties

RCT_REMAP_METHOD(mfzUserIsLoggedIn,
                 mfzUserIsLoggedInWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserIsLoggedInResolver:resolve];
}

RCT_REMAP_METHOD(mfzUserId,
                 mfzUserIdWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserIdResolver:resolve];
}

RCT_REMAP_METHOD(mfzUserGender,
                 mfzUserGenderWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserGenderResolver:resolve];
}

RCT_REMAP_METHOD(mfzUserSetGender,
                 newGender:(NSString *)newGender
                 mfzUserSetGenderWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserSetGender:newGender resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzUserEmail,
                 mfzUserEmailWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserEmailResolver:resolve];
}

RCT_REMAP_METHOD(mfzUserSetEmail,
                 newEmail:(NSString *)newEmail
                 mfzUserSetEmailWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserSetEmail:newEmail resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzUserMeasurementPreference,
                 mfzUserMeasurementPreferenceWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserMeasurementPreferenceResolver:resolve];
}

RCT_REMAP_METHOD(mfzUserSetMeasurementPreference,
                 newPreference:(NSString *)newMeasurementPreference
                 mfzUserSetMeasurementPreferenceWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserSetMeasurementPreference:newMeasurementPreference resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzUserWeightInKg,
                 mfzUserWeightInKgWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserWeightKgResolver:resolve];
}

RCT_REMAP_METHOD(mfzUserSetWeightInKg,
                 weight:(float)newWeightKg
                 mfzUserSetWeightInKgWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserSetWeightKg:newWeightKg resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzUserHeightInCm,
                 mfzUserHeightInCmWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserHeightCmResolver:resolve];
}

RCT_REMAP_METHOD(mfzUserSetHeightInCm,
                 height:(float)newHeightCm
                 mfzUserSetHeightInCmWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapUser mfzUserSetHeightCm:newHeightCm resolver:resolve rejecter:reject];
}

#pragma mark - RN Export Avatar

RCT_REMAP_METHOD(mfzAvatarDownloadMesh,
                 withId:(NSString *)attemptId
                 mfzAvatarDownloadMeshWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarDownloadMeshId:attemptId Resolver:resolve rejecter:reject];
}

#pragma mark - RN Export Avatar Properties

RCT_REMAP_METHOD(mfzAvatarHasDownloadedMesh,
                 withId:(NSString *)attemptId
                 mfzAvatarHasDownloadedMeshWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarHasDownloadedMeshId:attemptId Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarDate,
                 withId:(NSString *)attemptId
                 mfzAvatarDateWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarDateId:attemptId Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarGender,
                 withId:(NSString *)attemptId
                 mfzAvatarGenderWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarGenderId:attemptId Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarMeshCachedFile,
                 withId:(NSString *)attemptId
                 mfzAvatarMeshCachedFileWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarMeshFileId:attemptId Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarState,
                 withId:(NSString *)attemptId
                 mfzAvatarStateFileWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarStateId:attemptId Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarHeightInCm,
                 withId:(NSString *)attemptId
                 mfzAvatarHeightInCmWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarHeightCmId:attemptId Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarWeightInKg,
                 withId:(NSString *)attemptId
                 mfzAvatarWeightInKgWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarWeightKgId:attemptId Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarChestInCm,
                 withId:(NSString *)attemptId
                 mfzAvatarChestInCmWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarChestCmId:attemptId Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarWaistInCm,
                 withId:(NSString *)attemptId
                 mfzAvatarWaistInCmWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarWaistCmId:attemptId Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarHipInCm,
                 withId:(NSString *)attemptId
                 mfzAvatarHipInCmWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarHipCmId:attemptId Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarInseamInCm,
                 withId:(NSString *)attemptId
                 mfzAvatarInseamInCmWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarInseamCmId:attemptId Resolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarThighInCm,
                 withId:(NSString *)attemptId
                 mfzAvatarThighInCmWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarThighCmId:attemptId Resolver:resolve rejecter:reject];
}

#pragma mark - RN Export Avatar Manager

RCT_REMAP_METHOD(mfzAvatarMgrRequestAvatars,
                 mfzAvatarMgrRequestAvatarsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarMgrRequestWithResolver:resolve rejecter:reject];
}

RCT_REMAP_METHOD(mfzAvatarMgrDeleteAvatars,
                 list:(NSArray *)attemptIds
                 mfzAvatarMgrDeleteAvatarsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarMgrDelete:attemptIds Resolver:resolve rejecter:reject];
}

#pragma mark - RN Export Avatar Manager Properties

RCT_REMAP_METHOD(mfzAvatarMgrAllAvatars,
                 mfzAvatarMgrAllAvatarsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [RNMyFiziqWrapAvatar mfzAvatarMgrAllWithResolver:resolve rejecter:reject];
}

@end
  
