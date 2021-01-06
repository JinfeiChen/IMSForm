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

- (BOOL)isNotEmpty:(IMSFormModel *)model
{
    BOOL result = [IMSFormValidateManager isNotEmpty:model.value];
    if (!result) {
        [IMSDropHUD showAlertWithType:IMSFormMessageType_Error message:[NSString stringWithFormat:@"%@ 不能为空", model.title]];
    }
    return result;
}

@end
