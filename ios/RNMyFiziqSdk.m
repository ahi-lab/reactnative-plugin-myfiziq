
#import "RNMyFiziqSdk.h"
#import <MyFiziqSDK/MyFiziqSDK.h>

/*
 * This class is the RN facing interface. It should just be a proxy that invokes the native interfaces (such as SDK and bespoke view controllers).
 * RNMyFiziqSdk is based on MyFiziqSDK Cordova plugin, as there are similarities with the interface structure. All methods return via async.
 */

@implementation RNMyFiziqSdk

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE();

#pragma mark - RN Export Core

RCT_EXPORT_METHOD(mfzSdkSetupWithKey:(NSString *)key withSecret:(NSString *)secret withEnvironment:(NSString *)env)
{
}

RCT_EXPORT_METHOD(mfzSdkAnswerLoginsWithKey:(NSString *)idpKey withToken:(NSString *)idpToken)
{
}

RCT_EXPORT_METHOD(mfzSdkInitiateAvatarCreation)
{
}

#pragma mark - RN Export Core Properties

RCT_EXPORT_METHOD(mfzSdkStatusConnection)
{
}

RCT_EXPORT_METHOD(mfzSdkStatusVersion)
{
}

RCT_EXPORT_METHOD(mfzSdkAppId)
{
}

RCT_EXPORT_METHOD(mfzSdkVendorId)
{
}

RCT_EXPORT_METHOD(mfzSdkClientId)
{
}

RCT_EXPORT_METHOD(mfzSdkEnv)
{
}

RCT_EXPORT_METHOD(mfzSdkCognitoUserPoolId)
{
}

RCT_EXPORT_METHOD(mfzSdkCognitoUserPoolRegion)
{
}

RCT_EXPORT_METHOD(mfzSdkCognitoUserPoolLoginsKey)
{
}

#pragma mark - RN Export Style

RCT_EXPORT_METHOD(mfzSdkLoadCSS:(NSString *)cssPath)
{
}

#pragma mark - RN Export User

RCT_EXPORT_METHOD(mfzUserRegisterWithOptionalEmail:(NSString *)email)
{
}

RCT_EXPORT_METHOD(mfzUserLoginWithOptionalEmail:(NSString *)email)
{
}

RCT_EXPORT_METHOD(mfzUserLogout)
{
}

RCT_EXPORT_METHOD(mfzUserUpdateDetails)
{
}

#pragma mark - RN Export User Properties

RCT_EXPORT_METHOD(mfzUserIsLoggedIn)
{
}

RCT_EXPORT_METHOD(mfzUserId)
{
}

RCT_EXPORT_METHOD(mfzUserGender)
{
}

RCT_EXPORT_METHOD(mfzUserSetGender:(NSString *)newGender)
{
}

RCT_EXPORT_METHOD(mfzUserEmail)
{
}

RCT_EXPORT_METHOD(mfzUserSetEmail:(NSString *)newEmail)
{
}

RCT_EXPORT_METHOD(mfzUserMeasurementPreference)
{
}

RCT_EXPORT_METHOD(mfzUserSetMeasurementPreference:(NSString *)newMeasurementPreference)
{
}

RCT_EXPORT_METHOD(mfzUserWeightInKg)
{
}

RCT_EXPORT_METHOD(mfzUserSetWeightInKg:(float)newWeightKg)
{
}

RCT_EXPORT_METHOD(mfzUserHeightInCm)
{
}

RCT_EXPORT_METHOD(mfzUserSetHeightInCm:(float)newHeightCm)
{
}

#pragma mark - RN Export Avatar

RCT_EXPORT_METHOD(mfzAvatarDownloadMeshWithId:(NSString *)attemptId)
{
}

#pragma mark - RN Export Avatar Properties

RCT_EXPORT_METHOD(mfzAvatarHasDownloadedMesh:(NSString *)attemptId)
{
}

RCT_EXPORT_METHOD(mfzAvatarDate:(NSString *)attemptId)
{
}

RCT_EXPORT_METHOD(mfzAvatarGender:(NSString *)attemptId)
{
}

RCT_EXPORT_METHOD(mfzAvatarMeshCachedFile:(NSString *)attemptId)
{
}

RCT_EXPORT_METHOD(mfzAvatarState:(NSString *)attemptId)
{
}

RCT_EXPORT_METHOD(mfzAvatarHeightInCm:(NSString *)attemptId)
{
}

RCT_EXPORT_METHOD(mfzAvatarWeightInKg:(NSString *)attemptId)
{
}

RCT_EXPORT_METHOD(mfzAvatarChestInCm:(NSString *)attemptId)
{
}

RCT_EXPORT_METHOD(mfzAvatarWaistInCm:(NSString *)attemptId)
{
}

RCT_EXPORT_METHOD(mfzAvatarHipInCm:(NSString *)attemptId)
{
}

RCT_EXPORT_METHOD(mfzAvatarInseamInCm:(NSString *)attemptId)
{
}

RCT_EXPORT_METHOD(mfzAvatarThighInCm:(NSString *)attemptId)
{
}

#pragma mark - RN Export Avatar Manager

RCT_EXPORT_METHOD(mfzAvatarMgrRequestAvatars)
{
}

RCT_EXPORT_METHOD(mfzAvatarMgrDeleteAvatars:(NSArray *)attemptIds)
{
}

#pragma mark - RN Export Avatar Manager Properties

RCT_EXPORT_METHOD(mfzAvatarMgrAllAvatars)
{
}

@end
  
