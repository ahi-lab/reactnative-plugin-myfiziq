
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

/* Error codes for avatar. */
typedef NS_ENUM(NSInteger, RNMFZAvatarError) {
    /* No error. */
    RNMFZAvatarErrorOk = 0,
    /* No attempt id param error. */
    RNMFZAvatarErrorNoAttemptIdParam,
    /* Cannot download mesh for avatar as avatar either doesn't exist or is not completed. */
    RNMFZAvatarErrorCannotDownloadMeshAsAvatarNotReadyOrNonExist,
    /* Download mesh failed. */
    RNMFZAvatarErrorFailedDownloadMesh
};
#define RNMFZAVATAR_ERR_DOMAIN          @"com.myfiziq.rnsdk.avatar"

@interface RNMyFiziqWrapAvatar : NSObject
+ (void)mfzAvatarDownloadMeshId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
@end
