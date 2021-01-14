//
//  IMSFormModelNotEmptyValidator.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormModelNotEmptyValidator.h"
#import <IMSForm/IMSFormModel.h>

@implementation IMSFormModelNotEmptyValidator

- (BOOL)validateFormModel:(IMSFormModel *)formModel
{
    return formModel.value && (formModel.value.length != 0) && [formModel.value isKindOfClass:[NSString class]];
}

@end
