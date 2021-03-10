//
//  IMSFormTextFieldCPNConfig.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormTextFieldCPNConfig.h"

@implementation IMSFormTextFieldCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _textType = IMSFormTextType_Default;
        _lengthLimit = 100;
        _precision = 0;
        _unit = @"";
        _prefixUnit = @"";
        _suffixUnit = @"";
    }
    return self;
}

@end
