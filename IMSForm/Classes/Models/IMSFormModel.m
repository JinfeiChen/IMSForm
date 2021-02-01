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
        
        self.visible = YES;
        self.editable = YES;
        self.required = NO;
        self.clearable = YES;
        self.selected = NO;
        
        _title = @"";
        _info = @"";
    }
    return self;
}

#pragma mark - Getters

- (IMSFormCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormCPNConfig alloc] init];
    }
    return _cpnConfig;
}

- (IMSFormCPNStyle *)cpnStyle
{
    if (!_cpnStyle) {
        _cpnStyle = [[IMSFormCPNStyle alloc] init];
    }
    return _cpnStyle;
}

- (IMSFormCPNRule *)cpnRule
{
    if (!_cpnRule) {
        _cpnRule = [[IMSFormCPNRule alloc] init];
    }
    return _cpnRule;
}

- (NSMutableArray *)valueList {
    if (_valueList == nil) {
        _valueList = [[NSMutableArray alloc] init];
    }
    return _valueList;
}

@end
