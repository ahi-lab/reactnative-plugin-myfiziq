
#import "RNMyFiziqWrapAvatar.h"
#import <MyFiziqSDK/MyFiziqSDK.h>

@implementation RNMyFiziqWrapAvatar

+ (MyFiziqAvatar *)getAvatarForAttemptId:(NSString *)attemptId {
    NSArray<MyFiziqAvatar *> *allAvatars = [MyFiziqSDK shared].avatars.all;
    for (MyFiziqAvatar *av in allAvatars) {
        if ([av.attemptId isEqualToString:attemptId]) {
            return av;
        }
    }
    return nil;
}

// Avatar

+ (void)mfzAvatarDownloadMeshId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || avatar.state != MFZAvatarStateCompleted) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorCannotDownloadMeshAsAvatarNotReadyOrNonExist],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorCannotDownloadMeshAsAvatarNotReadyOrNonExist userInfo:nil]);
        } else {
            [avatar downloadMeshWithSuccess:^{
                if (resolve) resolve(nil);
            } failure:^(NSError *err) {
                if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorFailedDownloadMesh],
                                   RNMFZAVATAR_ERR_DOMAIN,
                                   [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorFailedDownloadMesh userInfo:@{NSLocalizedDescriptionKey:@(err.code)}]);
            } progress:nil];
        }
    }
}

+ (void)mfzAvatarHasDownloadedMeshId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || avatar.state != MFZAvatarStateCompleted) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorCannotDownloadMeshAsAvatarNotReadyOrNonExist],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorCannotDownloadMeshAsAvatarNotReadyOrNonExist userInfo:nil]);
        } else {
            if (resolve) resolve(avatar.hasDownloadedMesh ? @"true" : @"false");
        }
    }
}

// Returns UTC unix time (as double)
+ (void)mfzAvatarDateId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorCannotDownloadMeshAsAvatarNotReadyOrNonExist],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || !avatar.date) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoResult],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoResult userInfo:nil]);
        } else {
            if (resolve) resolve(@([avatar.date timeIntervalSince1970]));
        }
    }
}

+ (void)mfzAvatarGenderId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoResult],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoResult userInfo:nil]);
        } else {
            if (resolve) resolve(avatar.gender == MFZGenderMale ? @"male" : @"female");
        }
    }
}

+ (void)mfzAvatarMeshFileId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || ![avatar meshFile] || ![[avatar meshFile] isFileURL]) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoResult],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoResult userInfo:nil]);
        } else {
            if (resolve) resolve([avatar meshFile].path);
        }
    }
}

+ (void)mfzAvatarStateId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoResult],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoResult userInfo:nil]);
        } else {
            if (resolve) resolve(@(avatar.state));
        }
    }
}

+ (void)mfzAvatarHeightCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorCannotDownloadMeshAsAvatarNotReadyOrNonExist],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || !avatar.measurements || ![avatar.measurements objectForKey:@"heightCM"]) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoResult],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoResult userInfo:nil]);
        } else {
            if (resolve) resolve([avatar.measurements objectForKey:@"heightCM"]);
        }
    }
}

+ (void)mfzAvatarWeightKgId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || !avatar.measurements || ![avatar.measurements objectForKey:@"weightKG"]) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoResult],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoResult userInfo:nil]);
        } else {
            if (resolve) resolve([avatar.measurements objectForKey:@"weightKG"]);
        }
    }
}

+ (void)mfzAvatarChestCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || !avatar.measurements || ![avatar.measurements objectForKey:@"chestCM"]) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoResult],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoResult userInfo:nil]);
        } else {
            if (resolve) resolve([avatar.measurements objectForKey:@"chestCM"]);
        }
    }
}

+ (void)mfzAvatarWaistCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || !avatar.measurements || ![avatar.measurements objectForKey:@"waistCM"]) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoResult],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoResult userInfo:nil]);
        } else {
            if (resolve) resolve([avatar.measurements objectForKey:@"waistCM"]);
        }
    }
}

+ (void)mfzAvatarHipCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || !avatar.measurements || ![avatar.measurements objectForKey:@"hipsCM"]) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoResult],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoResult userInfo:nil]);
        } else {
            if (resolve) resolve([avatar.measurements objectForKey:@"hipsCM"]);
        }
    }
}

+ (void)mfzAvatarInseamCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || !avatar.measurements || ![avatar.measurements objectForKey:@"inseamCM"]) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoResult],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoResult userInfo:nil]);
        } else {
            if (resolve) resolve([avatar.measurements objectForKey:@"inseamCM"]);
        }
    }
}

+ (void)mfzAvatarThighCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || !avatar.measurements || ![avatar.measurements objectForKey:@"thighCM"]) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoResult],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoResult userInfo:nil]);
        } else {
            if (resolve) resolve([avatar.measurements objectForKey:@"thighCM"]);
        }
    }
}

// Avatar Manager

+ (void)mfzAvatarMgrRequestWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    [[MyFiziqSDK shared].avatars requestAvatarsWithSuccess:^{
        if (resolve) resolve(nil);
    } failure:^(NSError * _Nullable error) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorFailedPoll],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorFailedPoll userInfo:nil]);
    }];
}

+ (void)mfzAvatarMgrDelete:(NSArray *)attemptIds Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptIds) {
        if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorNoAttemptIdParam],
                           RNMFZAVATAR_ERR_DOMAIN,
                           [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        // Delete avatars
        [[MyFiziqSDK shared].avatars deleteAvatars:attemptIds success:^{
            if (resolve) resolve(nil);
        } failure:^(NSError * _Nullable error) {
            if (reject) reject([NSString stringWithFormat:@"%ld", RNMFZAvatarErrorFailedDelete],
                               RNMFZAVATAR_ERR_DOMAIN,
                               [NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorFailedDelete userInfo:nil]);
        }];
    }
}

+ (void)mfzAvatarMgrAllWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    if (!resolve) return;
    NSMutableArray<NSString *> *avatars = [[NSMutableArray alloc] initWithCapacity:[MyFiziqSDK shared].avatars.all.count];
    for (MyFiziqAvatar *avatar in [MyFiziqSDK shared].avatars.all) {
        [avatars addObject:avatar.attemptId];
    }
    if (resolve) resolve(avatars);
}

@end
