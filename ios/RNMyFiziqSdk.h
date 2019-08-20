
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#if __has_include("RCTEventDispatcher.h")
#import "RCTEventDispatcher.h"
#else
#import <React/RCTEventDispatcher.h>
#endif

/* Error codes for core. */
typedef NS_ENUM(NSInteger, RNMFZCoreError) {
    /* No error. */
    RNMFZCoreErrorOk = 0,
    /* Setup param(s) nil. */
    RNMFZCoreErrorSetupParamNil,
    /* Setup failed. */
    RNMFZCoreErrorSetupFailed,
    /* Answer logins param(s) nil. */
    RNMFZCoreErrorAnswerLoginsParamNil,
    /* Capture process failed. */
    RNMFZCoreErrorCaptureProcessFailed
};
#define RNMFZCORE_ERR_DOMAIN            @"com.myfiziq.rnsdk.core"
#define RNMFZCORE_EVENT_AUTH            @"myfiziqGetAuthToken"

@interface RNMyFiziqSdk : RCTEventDispatcher <RCTBridgeModule, MyFiziqSDKDelegate>

@end
  
