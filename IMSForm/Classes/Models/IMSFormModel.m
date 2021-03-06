//
//  IMSFormModel.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormModel.h"

@interface IMSFormModel ()

@property (strong, nonatomic) NSDictionary *tempDict; /**< <#property#> */

@end

@implementation IMSFormModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    _tempDict = dic;
    return YES;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if ([dic valueForKey:@"tempDict"]) {
        NSMutableDictionary *A = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSMutableDictionary *B = [NSMutableDictionary dictionaryWithDictionary:[dic valueForKey:@"tempDict"]];
        [B addEntriesFromDictionary:A];
        [dic addEntriesFromDictionary:B];
        [dic removeObjectForKey:@"tempDict"];
    }
    return YES;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.enable = YES;
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
    if (!_valueList) {
        _valueList = [[NSMutableArray alloc] init];
    }
    return _valueList;
}

@end
