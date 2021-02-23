//
//  IMSFormModelMobileValidator.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormModelMobileValidator.h"

@implementation IMSFormModelMobileValidator

- (NSError *)validateFormModel:(IMSFormModel *)formModel
{
    BOOL result = [IMSFormValidateManager isMobile:formModel.value];
    NSString *desc = [NSString stringWithFormat:@"[%@] - %@", formModel.title, @"Please enter the correct phone number".ims_localizable];
    return result ? nil : [NSError errorWithDomain:@"IMSFormModelMobileValidator_Error" code:-999 userInfo:@{ NSLocalizedDescriptionKey : desc }];
}

@end
