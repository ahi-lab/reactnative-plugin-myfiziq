
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

+ (void)mfzAvatarDownloadMeshId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    // Check param
    if (!attemptId) {
        if (reject) reject([NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorNoAttemptIdParam userInfo:nil]);
    } else {
        MyFiziqAvatar *avatar = [RNMyFiziqWrapAvatar getAvatarForAttemptId:attemptId];
        if (!avatar || avatar.state != MFZAvatarStateCompleted) {
            if (reject) reject([NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorCannotDownloadMeshAsAvatarNotReadyOrNonExist userInfo:nil]);
        } else {
            [avatar downloadMeshWithSuccess:^{
                if (resolve) resolve(nil);
            } failure:^(NSError *err) {
                if (reject) reject([NSError errorWithDomain:RNMFZAVATAR_ERR_DOMAIN code:RNMFZAvatarErrorFailedDownloadMesh userInfo:@{NSLocalizedDescriptionKey:@(err.code)}]);
            } progress:nil];
        }
    }
}

@end
