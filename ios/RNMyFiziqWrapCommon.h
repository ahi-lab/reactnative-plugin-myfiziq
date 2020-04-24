
#import <MyFiziqSDKCommon/MyFiziqCommon.h>

@interface RNMyFiziqWrapCommon : MyFiziqCommon <MyFiziqCommonProtocol>
@property (strong, nonatomic) NSDictionary *miscData;
@property (strong, nonatomic) NSString *sdkCssPathLocal;
+ (instancetype)shared;
@end
