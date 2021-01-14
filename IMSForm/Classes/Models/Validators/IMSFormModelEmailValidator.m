//
//  IMSFormModelEmailValidator.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormModelEmailValidator.h"

@implementation IMSFormModelEmailValidator

- (BOOL)validateFormModel:(IMSFormModel *)formModel
{
    return [IMSFormValidateManager isEmail:formModel.value];
}

@end
