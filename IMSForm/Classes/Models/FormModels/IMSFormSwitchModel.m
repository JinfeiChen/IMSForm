//
//  IMSFormSwitchModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormSwitchModel.h"

@implementation IMSFormSwitchModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.value = @"0";
    }
    return self;
}

@synthesize cpnStyle = _cpnStyle;

- (IMSFormSwitchCPNStyle *)cpnStyle
{
    if (!_cpnStyle) {
        _cpnStyle = [[IMSFormSwitchCPNStyle alloc] init];
    }
    return _cpnStyle;
}

@end
