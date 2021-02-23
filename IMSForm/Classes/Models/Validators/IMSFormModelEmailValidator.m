//
//  IMSFormModelEmailValidator.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormModelEmailValidator.h"

@implementation IMSFormModelEmailValidator

- (NSError *)validateFormModel:(IMSFormModel *)formModel
{
    BOOL result = [IMSFormValidateManager isEmail:formModel.value];
    NSString *desc = [NSString stringWithFormat:@"[%@] - %@", formModel.title, @"Please enter the correct e-mail address".ims_localizable];
    return result ? nil : [NSError errorWithDomain:@"IMSFormModelEmailValidator_Error" code:-999 userInfo:@{ NSLocalizedDescriptionKey : desc }];
}

@end
