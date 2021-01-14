//
//  IMSFormModelMobileValidator.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormModelMobileValidator.h"

@implementation IMSFormModelMobileValidator

- (BOOL)validateFormModel:(IMSFormModel *)formModel
{
    return [IMSFormValidateManager isMobile:formModel.value];
}

@end
