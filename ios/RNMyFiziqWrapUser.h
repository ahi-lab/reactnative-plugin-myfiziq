
#import <React/RCTBridgeModule.h>

/* Error codes for user. */
typedef NS_ENUM(NSInteger, RNMFZUserError) {
    /* No error. */
    RNMFZUserErrorOk = 0,
    /* Failed to register/announce user. */
    RNMFZUserErrorFailedRegistration,
    /* Failed to login user. */
    RNMFZUserErrorFailedLogin,
    /* Failed to logout user. */
    RNMFZUserErrorFailedLogout,
    /* Failed to update user details. */
    RNMFZUserErrorFailedUpdateDetails,
    /* Failed to set user gender due to bad param. */
    RNMFZUserErrorFailedSetGenderBadParam,
    /* Failed to set user email due to bad param. */
    RNMFZUserErrorFailedSetEmailBadParam,
    /* Failed to set measurement preference due to bad param. */
    RNMFZUserErrorFailedSetMeasurementPrefBadParam,
    /* Failed to set weight due to invalid param. */
    RNMFZUserErrorFailedSetWeightParamInvalid,
    /* Failed to set height due to invalid param. */
    RNMFZUserErrorFailedSetHeightParamInvalid
};
#define RNMFZUSER_ERR_DOMAIN            @"com.myfiziq.rnsdk.user"

@interface RNMyFiziqWrapUser : NSObject
+ (void)mfzUserRegisterEmail:(NSString *)email Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzUserLoginEmail:(NSString *)email Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzUserLogoutResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzUserUpdateDetailsResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzUserIsLoggedInResolver:(RCTPromiseResolveBlock)resolve;
+ (void)mfzUserIdResolver:(RCTPromiseResolveBlock)resolve;
+ (void)mfzUserGenderResolver:(RCTPromiseResolveBlock)resolve;
+ (void)mfzUserSetGender:(NSString *)gender resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzUserEmailResolver:(RCTPromiseResolveBlock)resolve;
+ (void)mfzUserSetEmail:(NSString *)email resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzUserMeasurementPreferenceResolver:(RCTPromiseResolveBlock)resolve;
+ (void)mfzUserSetMeasurementPreference:(NSString *)pref resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzUserWeightKgResolver:(RCTPromiseResolveBlock)resolve;
+ (void)mfzUserSetWeightKg:(float)weightKg resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzUserHeightCmResolver:(RCTPromiseResolveBlock)resolve;
+ (void)mfzUserSetHeightCm:(float)heightCm resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
@end

