//
//  IMSFormCPNRule.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormCPNRule.h"
#import <YYModel/YYModel.h>
#import <IMSForm/IMSFormModelValidator.h>

#define kValidatorsKeyPath @"validators"

@implementation IMSFormCPNRule

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSArray *validators = dic[kValidatorsKeyPath];
    NSMutableArray *mArr = [NSMutableArray array];
    for (id obj in validators) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [mArr addObject:[IMSFormModelValidator yy_modelWithDictionary:obj]];
        } else if ([obj isKindOfClass:[NSString class]]) {
            [mArr addObject:obj];
        } else {}
    }
    _validators = mArr;
    return YES;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (!_validators) return NO;
    NSMutableArray *mArr = [NSMutableArray array];
    for (id obj in _validators) {
        if ([obj isKindOfClass:[IMSFormModelValidator class]]) {
            [mArr addObject:[obj yy_modelToJSONObject]];
        } else if ([obj isKindOfClass:[NSString class]]) {
            [mArr addObject:obj];
        } else {}
    }
    dic[kValidatorsKeyPath] = mArr;
    return YES;
}

@end
