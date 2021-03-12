//
//  IMSFormTextViewCPNConfig.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormTextViewCPNConfig.h"

@implementation IMSFormTextViewCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _textType = IMSFormTextType_Default;
        _lengthLimit = 100;
        _localize = NO;
    }
    return self;
}

@end
