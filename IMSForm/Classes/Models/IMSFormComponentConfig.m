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
        _textType = IMSFormTextType_Default;
        _lengthLimit = 100;
        _precision = 0;
        _prefixUnit = @"";
        _suffixUnit = @"";
        _increment = 1.0;
        _min = 0.0;
        _max = 100000.0;
        _maxFilesLimit = 20;
    }
    return self;
}

@end
