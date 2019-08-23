
#import <React/RCTBridgeModule.h>

/* Error codes for avatar. */
typedef NS_ENUM(NSInteger, RNMFZCognitoAuthError) {
    /* No error. */
    RNMFZCognitoAuthErrorOk = 0,
    /* Invalid parameters. */
    RNMFZCognitoAuthErrorInvalidParams,
    /* Failed user login. */
    RNMFZCognitoAuthErrorFailedLogin,
    /* Failed password reset request. */
    RNMFZCognitoAuthErrorFailedPassResetRequest,
    /* Failed password reset confirm. */
    RNMFZCognitoAuthErrorFailedPassResetConfirm,
    /* Failed user logout. */
    RNMFZCognitoAuthErrorFailedLogout,
    /* Failed to get user token. */
    RNMFZCognitoAuthErrorFailedGetUserToken,
    /* Failed to re-authenticate the user. */
    RNMFZCognitoAuthErrorFailedUserReauth
};
#define RNMFZCOGNITOAUTH_ERR_DOMAIN          @"com.myfiziq.rnsdk.cognito.auth"

typedef NS_ENUM(NSUInteger, kMFZAuthValidation) {
    kMFZAuthValidationIsValid = 0,
    kMFZAuthValidationNoEmail,
    kMFZAuthValidationInvalidEmail,
    kMFZAuthValidationNoPassword,
    kMFZAuthValidationPasswordTooShort,
    kMFZAuthValidationPasswordsNotEqual,
    
};

@interface RNMyFiziqWrapCognitoAuth : NSObject
+ (instancetype)shared;
- (void)mfzCognitoUserSignedInResolver:(RCTPromiseResolveBlock)resolve;
- (void)mfzCognitoUserValidateInputEmail:(NSString *)email passA:(NSString *)passA passB:(NSString *)passB resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)mfzCognitoUserLoginEmail:(NSString *)email password:(NSString *)pass resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)mfzCognitoUserPasswordResetRequestEmail:(NSString *)email resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)mfzCognitoUserPasswordResetConfirmEmail:(NSString *)email resetCode:(NSString *)rcode newPassword:(NSString *)newPass resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)mfzCognitoUserLogoutResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)mfzCognitoUserTokenResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
- (void)mfzCognitoUserReauthenticateResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
@end
