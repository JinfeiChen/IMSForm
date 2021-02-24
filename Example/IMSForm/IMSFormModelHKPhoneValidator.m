//
//  IMSFormModelHKPhoneValidator.m
//  Raptor
//
//  Created by cjf on 9/2/2021.
//  Copyright © 2021 IMS. All rights reserved.
//

#import "IMSFormModelHKPhoneValidator.h"

@implementation IMSFormModelHKPhoneValidator

- (NSError *)validateFormModel:(IMSFormModel *)formModel 
{
    if (![formModel.type isEqualToString:IMSFormComponentType_Phone]) {
        return [NSError errorWithDomain:@"IMSFormModelHKPhoneValidator_Error" code:-999 userInfo:@{ NSLocalizedDescriptionKey : @"The calibrator or component is abnormal"}];
    }
    
    BOOL result = YES;
    NSString *phone = formModel.value;
    NSString *code = @"";
    if ((formModel.valueList && formModel.valueList.count > 0)) {
        code = [formModel.valueList.firstObject valueForKey:@"value"];
    }
    /**
     香港电话号码现时是用8个数位的
     51-56、59、6、90-98开头的号码为手机号码
     所以手机号码的正则表达式：
     /^(5[1234569]\d{6}|6\d{7}|9[0-8]\d{6})$/
     如果要加上区号（852）可以这样写
     /^(852)?(5[1234569]\d{6}|6\d{7}|9[0-8]\d{6})$/
     区号可要可不要，如果一定要，可以把问号去掉
     */
    // MARK: 业务需要，只校验香港号码，其他地区号码不校验
    if ([code isEqualToString:@"+852"]) {
        result = [IMSFormValidateManager validate:phone withRegex:@"^(5[1234569]\\d{6}|6\\d{7}|9[0-8]\\d{6})$"];
    }
    
    return result ? nil : [NSError errorWithDomain:@"IMSFormModelHKPhoneValidator_Error" code:-999 userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:@"[%@] - Please enter the correct phone number of HK", formModel.title]}];
}

@end
