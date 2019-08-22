
#import <React/RCTBridgeModule.h>

/* Error codes for avatar. */
typedef NS_ENUM(NSInteger, RNMFZAvatarError) {
    /* No error. */
    RNMFZAvatarErrorOk = 0,
    /* No attempt id param error. */
    RNMFZAvatarErrorNoAttemptIdParam,
    /* Cannot download mesh for avatar as avatar either doesn't exist or is not completed. */
    RNMFZAvatarErrorCannotDownloadMeshAsAvatarNotReadyOrNonExist,
    /* Download mesh failed. */
    RNMFZAvatarErrorFailedDownloadMesh,
    /* No avatar result. */
    RNMFZAvatarErrorNoResult,
    /* Failed to poll for new results. */
    RNMFZAvatarErrorFailedPoll,
    /* Failed to delete avatars requested. */
    RNMFZAvatarErrorFailedDelete
};
#define RNMFZAVATAR_ERR_DOMAIN          @"com.myfiziq.rnsdk.avatar"

@interface RNMyFiziqWrapAvatar : NSObject
// Avatar
+ (void)mfzAvatarDownloadMeshId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarHasDownloadedMeshId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarDateId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarGenderId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarMeshFileId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarStateId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarHeightCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarWeightKgId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarChestCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarWaistCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarHipCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarInseamCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarThighCmId:(NSString *)attemptId Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
// Avatar Manager
+ (void)mfzAvatarMgrRequestWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarMgrDelete:(NSArray *)attemptIds Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)mfzAvatarMgrAllWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
@end
