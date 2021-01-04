//
//  IMSMyValidateManager.m
//  IMSForm_Example
//
//  Created by cjf on 4/1/2021.
//  Copyright © 2021 jinfei_chen@icloud.com. All rights reserved.
//

#import "IMSMyValidateManager.h"

@implementation IMSMyValidateManager

#pragma mark - validate

- (BOOL)isEmpty:(IMSFormModel *)model
{
    NSLog(@"value: %@", model.value);
    return ![IMSFormValidateManager isEmpty:model.value];
}

- (BOOL)isPhone:(IMSFormModel *)model
{
    return [IMSFormValidateManager isMobile:model.value];
}

@end
