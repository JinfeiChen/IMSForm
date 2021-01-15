//
//  IMSFormModelURLValidator.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormModelURLValidator.h"

@implementation IMSFormModelURLValidator

- (BOOL)validateFormModel:(IMSFormModel *)formModel
{
    return [IMSFormValidateManager isURL:formModel.value];
}

@end
