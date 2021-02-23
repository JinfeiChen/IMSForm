//
//  IMSFormModelNotEmptyValidator.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormModelNotEmptyValidator.h"
#import <IMSForm/IMSFormModel.h>

@implementation IMSFormModelNotEmptyValidator

- (NSError *)validateFormModel:(IMSFormModel *)formModel
{
    BOOL result = YES;
    if (
        [formModel.type isEqualToString:IMSFormComponentType_Select] ||
        [formModel.type isEqualToString:IMSFormComponentType_MultiSelect] ||
        [formModel.type isEqualToString:IMSFormComponentType_Cascader] ||
        [formModel.type isEqualToString:IMSFormComponentType_Radio] ||
        [formModel.type isEqualToString:IMSFormComponentType_FileUpload] ||
        [formModel.type isEqualToString:IMSFormComponentType_ImageUpload] ||
        [formModel.type isEqualToString:IMSFormComponentType_InputTag] ||
        [formModel.type isEqualToString:IMSFormComponentType_InputSearch]
        ) {
        result = (formModel.valueList && (formModel.valueList.count > 0) && [formModel.valueList isKindOfClass:[NSArray class]]);
    }
    else if (
             [formModel.type isEqualToString:IMSFormComponentType_TextField] ||
             [formModel.type isEqualToString:IMSFormComponentType_TextView] ||
             [formModel.type isEqualToString:IMSFormComponentType_Number] ||
             [formModel.type isEqualToString:IMSFormComponentType_Switch] ||
             [formModel.type isEqualToString:IMSFormComponentType_Range] ||
             [formModel.type isEqualToString:IMSFormComponentType_Currency] ||
             [formModel.type isEqualToString:IMSFormComponentType_Phone] ||
             [formModel.type isEqualToString:IMSFormComponentType_Slider] ||
             [formModel.type isEqualToString:IMSFormComponentType_DateTimePicker]
             ) {
        result = (formModel.value && (formModel.value.length != 0) && [formModel.value isKindOfClass:[NSString class]]);
    }
    else {
        result = (formModel.value && (formModel.value.length != 0) && [formModel.value isKindOfClass:[NSString class]]);
    }
    NSString *desc = [NSString stringWithFormat:@"[%@] - %@", formModel.title, @"The content cannot be empty".ims_localizable];
    return result ? nil : [NSError errorWithDomain:@"IMSFormModelNotEmptyValidator_Error" code:-999 userInfo:@{ NSLocalizedDescriptionKey : desc}];
}

@end
