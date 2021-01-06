//
//  IMSFormComponentConfig.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormComponentConfig.h"

@implementation IMSFormComponentConfig

- (instancetype)init
{
    if (self = [super init]) {
        _multipleLimit = 100;
        _bodyAlign = IMSFormBodyAlign_Right;
        _textType = IMSFormTextType_Default;
        _lengthLimit = 100;
        _precision = 2;
        _prefixUnit = @"";
        _suffixUnit = @"";
    }
    return self;
}

@end
