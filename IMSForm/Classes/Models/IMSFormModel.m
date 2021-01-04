//
//  IMSFormModel.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormModel.h"

@implementation IMSFormModel

- (instancetype)init
{
    if (self = [super init]) {
        _visible = YES;
        _editable = YES;
        _required = NO;
        _clearable = YES;
    }
    return self;
}

#pragma mark - Getters

- (IMSFormComponentConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormComponentConfig alloc] init];
    }
    return _cpnConfig;
}

- (IMSFormComponentStyle *)cpnStyle
{
    if (!_cpnStyle) {
        _cpnStyle = [IMSFormComponentStyle defaultStyle];
    }
    return _cpnStyle;
}

- (IMSFormComponentRule *)cpnRule
{
    if (!_cpnRule) {
        _cpnRule = [[IMSFormComponentRule alloc] init];
    }
    return _cpnRule;
}

@end
