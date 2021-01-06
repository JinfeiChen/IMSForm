//
//  IMSFormValidateManager.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormValidateManager.h"

#import <objc/message.h>
#import <objc/runtime.h>

@implementation IMSFormValidateManager

+ (BOOL)validate:(NSString *)value withRegex:(NSString *)regex
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

+ (BOOL)isMobile:(NSString *)value
{
    return [self validate:value withRegex:@"^(1[3-9])\\d{9}$"];
}

+ (BOOL)isEmpty:(NSString *)value
{
    if (!value) return YES;
    if ([value isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([value isKindOfClass:[NSString class]])
    {
        if (value.length == 0)
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isNotEmpty:(NSString *)value
{
    return ![self isEmpty:value];
}

+ (BOOL)isEmail:(NSString *)value
{
    return [self validate:value withRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

+ (BOOL)validateFormDataSource:(NSArray<IMSFormModel *> *)dataArray
{
    for (IMSFormModel * _Nonnull model in dataArray) {
        if (model.isRequired && model.isEditable && model.isVisible) {
            if (model.cpnRule) {
                for (IMSFormValidator *validator in model.cpnRule.validators) {
                    Class cls = NSClassFromString(validator.className);
                    id obj = [[cls alloc] init];
                    if (!cls || !obj) {
                        NSLog(@"找不到校验器: %@", validator.className);
                        [IMSDropHUD showAlertWithType:IMSFormMessageType_Error message:[NSString stringWithFormat:@"找不到校验器: %@", validator.className]];
                        return NO;
                    }
                    NSString *str = [NSMutableString stringWithFormat:@"%@:", validator.selectorName];
                    SEL sel = NSSelectorFromString(str);
                    // 尝试执行实例对象的方法
                    if ([obj respondsToSelector:sel]) {
                        BOOL result = ((BOOL(*)(id, SEL, id))objc_msgSend)(obj, sel, model.value);
                        if (!result) {
                            NSLog(@"%@ 未通过实例方法 %@ 校验, value = %@", model.title, validator.selectorName, model.value);
                            [IMSDropHUD showAlertWithType:IMSFormMessageType_Error message:[NSString stringWithFormat:@"%@ 未通过实例方法 %@ 校验, value = %@", model.title, validator.selectorName, model.value]];
                            return NO;
                        }
                    }
                    // 尝试执行类对象的方法
                    else if ([cls respondsToSelector:sel]) {
                        BOOL result = ((BOOL(*)(id, SEL, id))objc_msgSend)(cls, sel, model.value);
                        if (!result) {
                            NSLog(@"%@ 未通过类方法 %@ 校验, value = %@", model.title, validator.selectorName, model.value);
                            [IMSDropHUD showAlertWithType:IMSFormMessageType_Error message:[NSString stringWithFormat:@"%@ 未通过类方法 %@ 校验, value = %@", model.title, validator.selectorName, model.value]];
                            return NO;
                        }
                    } else {
                        NSLog(@"未实现的校验方法: %@", validator.selectorName);
                        [IMSDropHUD showAlertWithType:IMSFormMessageType_Error message:[NSString stringWithFormat:@"未实现的校验方法: %@", validator.selectorName]];
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}

@end
