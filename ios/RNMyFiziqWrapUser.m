
#import "RNMyFiziqWrapUser.h"
#import <MyFiziqSDK/MyFiziqSDK.h>

@implementation RNMyFiziqWrapUser

+ (void)mfzUserRegisterEmail:(NSString *)email Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    [[MyFiziqSDK shared].user registerWithEmail:email completion:^(NSError *err, NSString *userid, NSString *clashid) {
        if (err) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZUserErrorFailedRegistration],
                               RNMFZUSER_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZUSER_ERR_DOMAIN code:RNMFZUserErrorFailedRegistration userInfo:@{NSLocalizedDescriptionKey:@(err.code)}]);
        } else {
            if (resolve) resolve(userid);
        }
    }];
}

+ (void)mfzUserLoginEmail:(NSString *)email Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    [[MyFiziqSDK shared].user logInWithEmail:email completion:^(NSError *err) {
        if (err) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZUserErrorFailedLogin],
                               RNMFZUSER_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZUSER_ERR_DOMAIN code:RNMFZUserErrorFailedLogin userInfo:@{NSLocalizedDescriptionKey:@(err.code)}]);
        } else {
            if (resolve) resolve(nil);
        }
    }];
}

+ (void)mfzUserLogoutResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    [[MyFiziqSDK shared].user logOutWithCompletion:^(NSError *err) {
        if (err) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZUserErrorFailedLogout],
                               RNMFZUSER_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZUSER_ERR_DOMAIN code:RNMFZUserErrorFailedLogout userInfo:@{NSLocalizedDescriptionKey:@(err.code)}]);
        } else {
            if (resolve) resolve(nil);
        }
    }];
}

+ (void)mfzUserUpdateDetailsResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    [[MyFiziqSDK shared].user updateDetailsWithCompletion:^(NSError *err) {
        if (err) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZUserErrorFailedLogout],
                               RNMFZUSER_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZUSER_ERR_DOMAIN code:RNMFZUserErrorFailedLogout userInfo:@{NSLocalizedDescriptionKey:@(err.code)}]);
        } else {
            if (resolve) resolve(nil);
        }
    }];
}

+ (void)mfzUserIsLoggedInResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve([MyFiziqSDK shared].user.isLoggedIn ? @"true" : @"false");
}

+ (void)mfzUserIdResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve(@([MyFiziqSDK shared].user.uid));
}

+ (void)mfzUserGenderResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve([MyFiziqSDK shared].user.gender == MFZGenderMale ? @"male" : @"female");
}

+ (void)mfzUserSetGender:(NSString *)gender resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check params
    if (!gender || (![gender isEqualToString:@"male"] && ![gender isEqualToString:@"female"])) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZUserErrorFailedSetGenderBadParam],
                           RNMFZUSER_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZUSER_ERR_DOMAIN code:RNMFZUserErrorFailedSetGenderBadParam userInfo:@{NSLocalizedDescriptionKey:@"Param must be either 'male' or 'female'."}]);
    } else {
        [MyFiziqSDK shared].user.gender = [gender isEqualToString:@"male"] ? MFZGenderMale : MFZGenderFemale;
        if (resolve) resolve(nil);
    }
}

+ (void)mfzUserEmailResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve([MyFiziqSDK shared].user.email);
}

+ (void)mfzUserSetEmail:(NSString *)email resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check params
    if (!email) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZUserErrorFailedSetEmailBadParam],
                           RNMFZUSER_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZUSER_ERR_DOMAIN code:RNMFZUserErrorFailedSetEmailBadParam userInfo:nil]);
    } else {
        [MyFiziqSDK shared].user.email = email;
        if (resolve) resolve(nil);
    }
}

+ (void)mfzUserMeasurementPreferenceResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve([MyFiziqSDK shared].user.measurementPreference == MFZMeasurementMetric ? @"metric" : @"imperial");
}

+ (void)mfzUserSetMeasurementPreference:(NSString *)pref resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    if (!pref || (![pref isEqualToString:@"metric"] && ![pref isEqualToString:@"imperial"])) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZUserErrorFailedSetMeasurementPrefBadParam],
                           RNMFZUSER_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZUSER_ERR_DOMAIN code:RNMFZUserErrorFailedSetMeasurementPrefBadParam userInfo:@{NSLocalizedDescriptionKey:@"Param must be either 'metric' or 'imperial'."}]);
    } else {
        [MyFiziqSDK shared].user.measurementPreference = [pref isEqualToString:@"metric"] ? MFZMeasurementMetric : MFZMeasurementImperial;
        if (resolve) resolve(nil);
    }
}

+ (void)mfzUserWeightKgResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve(@([MyFiziqSDK shared].user.weightInKg));
}

+ (void)mfzUserSetWeightKg:(float)weightKg resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check params
    if (weightKg < 17 || weightKg > 300) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZUserErrorFailedSetWeightParamInvalid],
                           RNMFZUSER_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZUSER_ERR_DOMAIN code:RNMFZUserErrorFailedSetWeightParamInvalid userInfo:@{NSLocalizedDescriptionKey:@"Param value must be between 17 and 300 kg."}]);
    } else {
        [MyFiziqSDK shared].user.weightInKg = weightKg;
        if (resolve) resolve(nil);
    }
}

+ (void)mfzUserHeightCmResolver:(RCTPromiseResolveBlock)resolve {
    if (resolve) resolve(@([MyFiziqSDK shared].user.heightInCm));
}

+ (void)mfzUserSetHeightCm:(float)heightCm resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check params
    if (heightCm < 50 || heightCm > 300) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZUserErrorFailedSetHeightParamInvalid],
                           RNMFZUSER_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZUSER_ERR_DOMAIN code:RNMFZUserErrorFailedSetHeightParamInvalid userInfo:@{NSLocalizedDescriptionKey:@"Param value must be between 50 and 300 cm."}]);
    } else {
        [MyFiziqSDK shared].user.heightInCm = heightCm;
        if (resolve) resolve(nil);
    }
}

@end
