//
//  IMSFormModelURLValidator.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormModelURLValidator.h"

@implementation IMSFormModelURLValidator

- (NSError *)validateFormModel:(IMSFormModel *)formModel
{
    BOOL result = [IMSFormValidateManager isURL:formModel.value];
    return result ? nil : [NSError errorWithDomain:@"IMSFormModelURLValidator_Error" code:-999 userInfo:@{ NSLocalizedDescriptionKey : @"Please enter the correct URL address".ims_localizable}];
}

@end
