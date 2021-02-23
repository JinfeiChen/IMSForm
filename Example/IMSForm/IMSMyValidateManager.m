//
//  IMSMyValidateManager.m
//  IMSForm_Example
//
//  Created by cjf on 4/1/2021.
//  Copyright © 2021 jinfei_chen@icloud.com. All rights reserved.
//

#import "IMSMyValidateManager.h"

@implementation IMSMyValidateManager

#pragma mark - custom validators

- (NSError *)isNotEmpty:(IMSFormModel *)model
{
    BOOL result = [IMSFormValidateManager isNotEmpty:model.value];
    return result ? nil : [NSError errorWithDomain:@"IMSMyValidateManager_Error" code:-999 userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%@ 不能为空", model.title]}];
}

- (NSError *)isEmail:(IMSFormModel *)model
{
    BOOL result = [IMSFormValidateManager isEmail:model.value];
    return result ? nil : [NSError errorWithDomain:@"IMSMyValidateManager_Error" code:-999 userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:@"%@ 邮箱地址不合法", model.title]}];
}

@end
