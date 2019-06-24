
#import "RNMyFiziqWrapCommon.h"

@implementation RNMyFiziqWrapCommon

#pragma mark - Methods

+ (instancetype)shared {
    static RNMyFiziqWrapCommon *mfzCommon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mfzCommon = [[RNMyFiziqWrapCommon alloc] init];
        [[MyFiziqCommon shared] insert:mfzCommon];
    });
    return mfzCommon;
}

- (NSBundle *)sdkBundle {
    return [NSBundle mainBundle];
}

- (NSString *)sdkCssName {
    return @"app-myfiziq";
}

- (NSString *)sdkStringsTable {
    return @"Localizable";
}

@end
