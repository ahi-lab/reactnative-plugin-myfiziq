
#import "RNMyFiziqWrapCognitoAuth.h"
#import <React/RCTLog.h>
#import <MyFiziqSDK/MyFiziqSDK.h>
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSCognitoIdentityProvider/AWSCognitoIdentityProvider.h>
#import <SHEmailValidator/SHEmailValidator.h>

#define MYQ_APP_NAME            @"RNMyFiziqSDKWrap"
#define MIN_PASSWORD_LENGTH     6
#define MAX_AUTH_TIMEOUT_SEC    60

@interface RNMyFiziqWrapCognitoAuth()
@property (strong, nonatomic) NSString *cognitoUserPoolRegion;
@property (strong, nonatomic) NSString *cognitoUserPoolId;
@property (strong, nonatomic) NSString *cognitoClientId;
@property (strong, nonatomic) AWSServiceConfiguration *awsServiceConfiguration;
@property (strong, nonatomic) AWSCognitoIdentityUserPoolConfiguration *awsUserPoolConfig;
@property (strong, nonatomic) AWSCognitoIdentityUserPool *awsUserPool;
@property (readonly, nonatomic) AWSCognitoIdentityUser *currentUser;
@property (readonly, nonatomic) NSString *idpUserToken;
@end

@implementation RNMyFiziqWrapCognitoAuth

#pragma mark - Properties

- (NSString *)cognitoUserPoolRegion {
  if (!_cognitoUserPoolRegion) {
    _cognitoUserPoolRegion = [MyFiziqSDK shared].cognitoUserPoolRegion;
  }
  return _cognitoUserPoolRegion;
}

- (NSString *)cognitoUserPoolId {
  if (!_cognitoUserPoolId) {
    _cognitoUserPoolId = [MyFiziqSDK shared].cognitoUserPoolId;
  }
  return _cognitoUserPoolId;
}

- (NSString *)cognitoClientId {
  if (!_cognitoClientId) {
    _cognitoClientId = [MyFiziqSDK shared].clientId;
  }
  return _cognitoClientId;
}

- (AWSServiceConfiguration *)awsServiceConfiguration {
  if (!_awsServiceConfiguration) {
    _awsServiceConfiguration = [[AWSServiceConfiguration alloc] initWithRegion:[self.cognitoUserPoolRegion aws_regionTypeValue]
                                                           credentialsProvider:nil];
  }
  return _awsServiceConfiguration;
}

- (AWSCognitoIdentityUserPoolConfiguration *)awsUserPoolConfig {
  if (!_awsUserPoolConfig) {
    _awsUserPoolConfig = [[AWSCognitoIdentityUserPoolConfiguration alloc] initWithClientId:self.cognitoClientId
                                                                              clientSecret:nil
                                                                                    poolId:self.cognitoUserPoolId];
  }
  return _awsUserPoolConfig;
}

- (AWSCognitoIdentityUserPool *)awsUserPool {
  if (!_awsUserPool) {
    [AWSCognitoIdentityUserPool registerCognitoIdentityUserPoolWithConfiguration:self.awsServiceConfiguration
                                                           userPoolConfiguration:self.awsUserPoolConfig
                                                                          forKey:MYQ_APP_NAME];
    _awsUserPool = [AWSCognitoIdentityUserPool CognitoIdentityUserPoolForKey:MYQ_APP_NAME];
  }
  return _awsUserPool;
}

- (AWSCognitoIdentityUser *)currentUser {
  return [self.awsUserPool currentUser];
}

#pragma mark - Methods

+ (instancetype)shared {
  static RNMyFiziqWrapCognitoAuth *mfzAuth = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mfzAuth = [[RNMyFiziqWrapCognitoAuth alloc] init];
  });
  return mfzAuth;
}

- (void)mfzCognitoUserSignedInResolver:(RCTPromiseResolveBlock)resolve {
  if (resolve) resolve([self userIsSignedIn] ? @"true" : @"false");
}

- (void)mfzCognitoUserValidateInputEmail:(NSString *)email passA:(NSString *)passA passB:(NSString *)passB resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject
{
  // Check params
  if (!email || !passA || !passB) {
    if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCognitoAuthErrorInvalidParams],
                       RNMFZCOGNITOAUTH_ERR_DOMAIN,
                       [NSError errorWithDomain:RNMFZCOGNITOAUTH_ERR_DOMAIN code:RNMFZCognitoAuthErrorInvalidParams userInfo:nil]);
  } else {
    kMFZAuthValidation res = [self validateEmail:email passwordA:passA passwordB:passB];
    if (resolve) resolve(@(res));
  }
}

- (void)mfzCognitoUserLoginEmail:(NSString *)email password:(NSString *)pass resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
  // Check params
  if (!email || !pass) {
    if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCognitoAuthErrorInvalidParams],
                       RNMFZCOGNITOAUTH_ERR_DOMAIN,
                       [NSError errorWithDomain:RNMFZCOGNITOAUTH_ERR_DOMAIN code:RNMFZCognitoAuthErrorInvalidParams userInfo:nil]);
  } else {
    [self userLoginWithEmail:email password:pass completion:^(NSError *err) {
      if (err) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCognitoAuthErrorInvalidParams],
                           RNMFZCOGNITOAUTH_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZCOGNITOAUTH_ERR_DOMAIN code:RNMFZCognitoAuthErrorInvalidParams userInfo:nil]);
      } else {
        if (resolve) resolve(nil);
      }
    }];
  }
}

- (void)mfzCognitoUserPasswordResetRequestEmail:(NSString *)email resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
  // Check params
  if (!email) {
    if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCognitoAuthErrorInvalidParams],
                       RNMFZCOGNITOAUTH_ERR_DOMAIN,
                       [NSError errorWithDomain:RNMFZCOGNITOAUTH_ERR_DOMAIN code:RNMFZCognitoAuthErrorInvalidParams userInfo:nil]);
  } else {
    [self userPasswordResetRequestWithEmail:email completion:^(NSError *err) {
      if (err) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCognitoAuthErrorFailedPassResetRequest],
                           RNMFZCOGNITOAUTH_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZCOGNITOAUTH_ERR_DOMAIN code:RNMFZCognitoAuthErrorFailedPassResetRequest userInfo:nil]);
      } else {
        if (resolve) resolve(nil);
      }
    }];
  }
}

- (void)mfzCognitoUserPasswordResetConfirmEmail:(NSString *)email resetCode:(NSString *)rcode newPassword:(NSString *)newPass resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
  // Check params
  if (!email || !rcode || !newPass) {
    if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCognitoAuthErrorInvalidParams],
                       RNMFZCOGNITOAUTH_ERR_DOMAIN,
                       [NSError errorWithDomain:RNMFZCOGNITOAUTH_ERR_DOMAIN code:RNMFZCognitoAuthErrorInvalidParams userInfo:nil]);
  } else {
    [self userPasswordResetConfirmWithEmail:email resetCode:rcode newPassword:newPass completion:^(NSError *err) {
      if (err) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCognitoAuthErrorFailedPassResetConfirm],
                           RNMFZCOGNITOAUTH_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZCOGNITOAUTH_ERR_DOMAIN code:RNMFZCognitoAuthErrorFailedPassResetConfirm userInfo:nil]);
      } else {
        if (resolve) resolve(nil);
      }
    }];
  }
}

- (void)mfzCognitoUserLogoutResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
  [self userLogoutWithCompletion:^(NSError *err) {
    if (err) {
      if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCognitoAuthErrorFailedLogout],
                         RNMFZCOGNITOAUTH_ERR_DOMAIN,
                         [NSError errorWithDomain:RNMFZCOGNITOAUTH_ERR_DOMAIN code:RNMFZCognitoAuthErrorFailedLogout userInfo:nil]);
    } else {
      if (resolve) resolve(nil);
    }
  }];
}

- (void)mfzCognitoUserTokenResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
  [self getUserToken:^(NSString *token) {
    if (token) {
      if (resolve) resolve(token);
    } else {
      if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCognitoAuthErrorFailedGetUserToken],
                         RNMFZCOGNITOAUTH_ERR_DOMAIN,
                         [NSError errorWithDomain:RNMFZCOGNITOAUTH_ERR_DOMAIN code:RNMFZCognitoAuthErrorFailedGetUserToken userInfo:nil]);
    }
  }];
}

- (void)mfzCognitoUserReauthenticateResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
  [[self userReauthenticate] continueWithBlock:^id _Nullable(AWSTask * _Nonnull t) {
    if (t.error) {
      if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZCognitoAuthErrorFailedUserReauth],
                         RNMFZCOGNITOAUTH_ERR_DOMAIN,
                         [NSError errorWithDomain:RNMFZCOGNITOAUTH_ERR_DOMAIN code:RNMFZCognitoAuthErrorFailedUserReauth userInfo:nil]);
    } else {
      if (resolve) resolve(nil);
    }
    return nil;
  }];
}

#pragma mark - UserPool Helpers

- (BOOL)userIsSignedIn {
  return (self.currentUser && self.currentUser.username && ![self.currentUser.username isEqualToString:@""] && self.currentUser.isSignedIn);
}

/*
 NOTE: This method check if the data entered into the fields are valid. Return if user authentication can proceed.
 */
- (kMFZAuthValidation)validateEmail:(NSString *)email passwordA:(NSString *)passA passwordB:(NSString *)passB {
  // NOTE: Validate email.
  if (!email || [email isEqualToString:@""]) {
    return kMFZAuthValidationNoEmail;
  }
  NSError *error;
  [[SHEmailValidator validator] validateSyntaxOfEmailAddress:email withError:&error];
  if (error) {
    return kMFZAuthValidationInvalidEmail;
  }
  // NOTE: Validate password.
  if (!passA || !passB || [passA isEqualToString:@""] || [passB isEqualToString:@""]) {
    return kMFZAuthValidationNoPassword;
  }
  if (passA.length < MIN_PASSWORD_LENGTH) {
    return kMFZAuthValidationPasswordTooShort;
  }
  if (![passA isEqualToString:passB]) {
    return kMFZAuthValidationPasswordsNotEqual;
  }
  // NOTE: Inputs did not return as invalid, so return as valid.
  return kMFZAuthValidationIsValid;
}

/*
 NOTE: Attempts to authenticate the user with the AWS Cognito User Pool idP service.
 */
- (void)userLoginWithEmail:(NSString *)email password:(NSString *)pass completion:(void (^)(NSError *err))completion {
  // NOTE: Make sure parameters are valid.
  kMFZAuthValidation validation = [self validateEmail:email passwordA:pass passwordB:pass];
  if (validation != kMFZAuthValidationIsValid) {
    RCTLogError(@"ERROR: Parameters are invalid for user login. Check with -validateEmail:passwordA:passwordB method first.");
    if (completion) {
      completion([NSError errorWithDomain:@"com.myfiziq" code:-4 userInfo:nil]);
    }
    return;
  }
  // NOTE: Attempt user authentication.
  AWSCognitoIdentityUser *user = [self.awsUserPool getUser:email];
  if (user) {
    __block BOOL didRespond = NO;
    AWSCancellationTokenSource *cancellationTokenSource = [AWSCancellationTokenSource cancellationTokenSource];
    [[user getSession:email password:pass validationData:nil] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityUserSession *> * _Nonnull t) {
      if (t.error) {
        RCTLogError(@"ERROR: Failed to authenticate the user.");
        didRespond = YES;
        if (completion) {
          completion(t.error);
        }
      } else {
        RCTLogInfo(@"Successfully authenticated the user.");
        didRespond = YES;
        if (completion) {
          completion(nil);
        }
      }
      return nil;
    } cancellationToken:cancellationTokenSource.token];
    // NOTE: Incase the service does not timeout in a timely manner, the authentication attempt should be cancelled
    // after a certain timeout period has elapsed.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MAX_AUTH_TIMEOUT_SEC * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      if (!didRespond && completion) {
        RCTLogError(@"ERROR: Authentication of user timed out.");
        completion([NSError errorWithDomain:@"com.myfiziq" code:-3 userInfo:nil]);
      }
    });
  } else {
    // NOTE: This example uses the NSError parameter to flag that the authentication failed.
    RCTLogError(@"ERROR: User not found.");
    if (completion) {
      completion([NSError errorWithDomain:@"com.myfiziq" code:-2 userInfo:nil]);
    }
  }
}

/*
 OPTIONAL: AWS Cognito User Pool service will handle the generation and send of the registered user's password reset code.
 */
- (void)userPasswordResetRequestWithEmail:(NSString *)email completion:(void (^)(NSError *))completion {
  // NOTE: Make sure parameters are valid.
  kMFZAuthValidation validation = [self validateEmail:email passwordA:@"dummy_password" passwordB:@"dummy_password"];
  if (validation != kMFZAuthValidationIsValid) {
    RCTLogError(@"ERROR: Parameters are invalid for user password reset. Check with -validateEmail:passwordA:passwordB method first.");
    if (completion) {
      completion([NSError errorWithDomain:@"com.myfiziq" code:-4 userInfo:nil]);
    }
    return;
  }
  // NOTE: Attempt user authentication.
  AWSCognitoIdentityUser *user = [self.awsUserPool getUser:email];
  if (user) {
    __block BOOL didRespond = NO;
    AWSCancellationTokenSource *cancellationTokenSource = [AWSCancellationTokenSource cancellationTokenSource];
    [[user forgotPassword] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityUserForgotPasswordResponse *> * _Nonnull t) {
      if (t.error) {
        RCTLogError(@"ERROR: Failed to send reset password code to the user.");
        if (completion) {
          completion(t.error);
        }
      } else {
        RCTLogInfo(@"Successfully sent reset password code to the user.");
        if (completion) {
          completion(nil);
        }
      }
      didRespond = YES;
      return nil;
    } cancellationToken:cancellationTokenSource.token];
    // NOTE: Incase the service does not timeout in a timely manner, the authentication attempt should be cancelled
    // after a certain timeout period has elapsed.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MAX_AUTH_TIMEOUT_SEC * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      if (!didRespond && completion) {
        RCTLogError(@"ERROR: Submit of password reset code timed out.");
        completion([NSError errorWithDomain:@"com.myfiziq" code:-3 userInfo:nil]);
      }
    });
  } else {
    // NOTE: This example uses the NSError parameter to flag that the authentication failed.
    RCTLogError(@"ERROR: User not found.");
    if (completion) {
      completion([NSError errorWithDomain:@"com.myfiziq" code:-2 userInfo:nil]);
    }
  }
}

/*
 OPTIONAL: To reset the user password, the user must answer
 */
- (void)userPasswordResetConfirmWithEmail:(NSString *)email resetCode:(NSString *)code newPassword:(NSString *)pass completion:(void (^)(NSError *))completion {
  // NOTE: Make sure parameters are valid.
  kMFZAuthValidation validation = [self validateEmail:email passwordA:pass passwordB:pass];
  if (validation != kMFZAuthValidationIsValid || !code || [code isEqualToString:@""]) {
    RCTLogError(@"ERROR: Parameters are invalid for user password reset. Check with -validateEmail:passwordA:passwordB method first.");
    if (completion) {
      completion([NSError errorWithDomain:@"com.myfiziq" code:-4 userInfo:nil]);
    }
    return;
  }
  // NOTE: Attempt user password reset.
  AWSCognitoIdentityUser *user = [self.awsUserPool getUser:email];
  if (user) {
    __block BOOL didRespond = NO;
    AWSCancellationTokenSource *cancellationTokenSource = [AWSCancellationTokenSource cancellationTokenSource];
    [[user confirmForgotPassword:code password:pass] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityUserConfirmForgotPasswordResponse *> * _Nonnull t) {
      if (t.error) {
        RCTLogError(@"ERROR: Failed to reset user password.");
        didRespond = YES;
        if (completion) {
          completion(t.error);
        }
      } else {
        RCTLogInfo(@"Successfully reset user password.");
        // NOTE: Login the new user using the new password.
        [self userLoginWithEmail:email password:pass completion:^(NSError *loginErr) {
          didRespond = YES;
          if (completion) {
            completion(nil);
          }
        }];
      }
      return nil;
    } cancellationToken:cancellationTokenSource.token];
    // NOTE: Incase the service does not timeout in a timely manner, the authentication attempt should be cancelled
    // after a certain timeout period has elapsed.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MAX_AUTH_TIMEOUT_SEC * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      if (!didRespond && completion) {
        RCTLogError(@"ERROR: Password reset timed out.");
        completion([NSError errorWithDomain:@"com.myfiziq" code:-3 userInfo:nil]);
      }
    });
  } else {
    // NOTE: This example uses the NSError parameter to flag that the authentication failed.
    RCTLogError(@"ERROR: User not found.");
    if (completion) {
      completion([NSError errorWithDomain:@"com.myfiziq" code:-2 userInfo:nil]);
    }
  }
}

- (AWSTask *)userReauthenticate {
  if ([self userIsSignedIn]) {
    return [self.currentUser getSession];
  } else {
    // NOTE: Error to signify that there is no existing user session.
    return [AWSTask taskWithError:[NSError errorWithDomain:@"com.myfiziq" code:-1 userInfo:nil]];
  }
}

- (void)userLogoutWithCompletion:(void (^)(NSError *))completion {
  // NOTE: Check if there is a user to logout.
  if (self.userIsSignedIn) {
    [self.currentUser signOutAndClearLastKnownUser];
    if (completion) {
      completion(nil);
    }
  } else if (completion) {
    // NOTE: To signify that there were no user session to logout of.
    completion([NSError errorWithDomain:@"com.myfiziq" code:2 userInfo:nil]);
  }
}

- (void)getUserToken:(void (^)(NSString *token))completion {
  [[self.currentUser getSession] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityUserSession *> * _Nonnull t) {
    if (completion) {
      if (t.error) {
        completion(nil);
      } else {
        completion(t.result.idToken.tokenString);
      }
    }
    return nil;
  }];
}

@end
