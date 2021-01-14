//
//  IMSFormValidateManager.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormValidateManager.h"

#import <objc/message.h>
#import <objc/runtime.h>
#import <IMSForm/IMSFormModelValidator.h>

@implementation IMSFormValidateManager

+ (BOOL)validate:(NSString *)value withRegex:(NSString *)regex
{
    if (!value || ![value isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (!regex || ![regex isKindOfClass:[NSString class]]) {
        return NO;
    }
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

+ (BOOL)isMobile:(NSString *)value
{
    return [self validate:value withRegex:@"^(1[3-9])\\d{9}$"];
}

+ (BOOL)isEmpty:(NSString *)value
{
    return !value || (value.length == 0) || ![value isKindOfClass:[NSString class]];
}

+ (BOOL)isNotEmpty:(NSString *)value
{
    return ![self validate:value withRegex:@"^$"];
}

+ (BOOL)isEmail:(NSString *)value
{
    return [self validate:value withRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

+ (BOOL)isNumber:(NSString *)value
{
    return [self validate:value withRegex:@"^[0-9]*$"];
}

+ (BOOL)isFloatNumber:(NSString *)value
{
    return [self validate:value withRegex:@"^[0-9]+([.]{1}[0-9]+){0,1}$"];
}

+ (BOOL)isURL:(NSString *)value
{
    return [self validate:value withRegex:@"^[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+(:[0-9]{1,5})?[-a-zA-Z0-9()@:%_\\\+\.~#?&//=]*$"];
}

+ (NSError *)validateFormDataSource:(NSArray<IMSFormModel *> *)dataArray
{
    NSError *error = nil;
    for (IMSFormModel * _Nonnull model in dataArray) {
        if (model.isRequired && model.isEditable && model.isVisible) {
            if (model.cpnRule) {
                for (id obj in model.cpnRule.validators) {
                    if ([obj isKindOfClass:[IMSFormModelValidator class]]) {
                        
                        IMSFormModelValidator *validator = (IMSFormModelValidator *)obj;
                        Class cls = NSClassFromString(validator.className);
                        SEL sel = NSSelectorFromString([NSMutableString stringWithFormat:@"%@:", validator.selectorName]);
                        error = [self callValidatorWithClass:cls selector:sel formModel:model];
                        if (error) {
                            NSLog(@"validate error: %@", error.localizedDescription);
                            error = validator.failure.message ? [NSError errorWithDomain:@"IMSFormModelValidatorError" code:-999 userInfo:@{ NSLocalizedDescriptionKey : validator.failure.message}] : error;
                            return error;
                        }
                        
                    } else if ([obj isKindOfClass:[NSString class]]) {
                        
                        Class cls = NSClassFromString(obj);
                        SEL sel = NSSelectorFromString(@"validateFormModel:");
                        error = [self callValidatorWithClass:cls selector:sel formModel:model];
                        if (error) {
                            NSLog(@"validate error: %@", error.localizedDescription);
                            return error;
                        }
                        
                    } else {}
                    
                }
            }
        }
    }
    return error;
}

#pragma mark - Private Methods

+ (NSError *)callValidatorWithClass:(Class)cls selector:(SEL)sel formModel:(IMSFormModel *)model
{
    NSLog(@"%@ validate: %@", NSStringFromSelector(sel), model.value);
    
    NSError *error = nil;
    NSString *desc = nil;
    id obj = [[cls alloc] init];
    if (!desc && (!cls || !obj)) {
        desc = [NSString stringWithFormat:@"No validator found: %@", NSStringFromClass(cls)];
    }
    // 尝试执行实例对象的方法
    if (!desc) {
        if ([obj respondsToSelector:sel]) {
            BOOL result = ((BOOL(*)(id, SEL, id))objc_msgSend)(obj, sel, model);
            if (!result) {
                desc = [NSString stringWithFormat:@"%@ 未通过实例方法 %@ 校验, value = %@", model.title, NSStringFromSelector(sel), model.value];
            }
        }
        // 尝试执行类对象的方法
        else if ([cls respondsToSelector:sel]) {
            BOOL result = ((BOOL(*)(id, SEL, IMSFormModel *))objc_msgSend)(cls, sel, model);
            if (!result) {
                desc = [NSString stringWithFormat:@"%@ 未通过类方法 %@ 校验, value = %@", model.title, NSStringFromSelector(sel), model.value];
            }
        } else {
            desc = [NSString stringWithFormat:@"未实现的校验方法: %@", NSStringFromSelector(sel)];
        }
    }
    if (desc) {
        error = [NSError errorWithDomain:@"IMSFormModelValidatorError" code:-999 userInfo:@{ NSLocalizedDescriptionKey : desc}];
    }
    return error;
}

@end
