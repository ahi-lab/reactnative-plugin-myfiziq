#import <MyFiziqSDKCommon/MyFiziqCommon.h>

@interface RNMyFiziqWrapCommon : MyFiziqCommon <MyFiziqCommonProtocol>
@property (strong, nonatomic) MyFiziqCommon *common;
@property (strong, nonatomic) NSString *sdkCssPathLocal;
+ (instancetype)shared;
@end
