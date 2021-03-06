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
#import <IMSForm/NSString+Extension.h>

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
    for (IMSFormModel *_Nonnull model in dataArray) {
        if (error) {
            break;
        }

        if (model.isEnable && model.isEditable && model.isVisible) {
            if (model.cpnRule) {
                /**
                 必填项：无论是否设置校验器，都自动添加非空校验器；
                 非必填项：空数据（未输入任何内容）时，不执行任何校验；数据不为空&设置了校验器，则执行校验；
                 */
                BOOL executeValidate = YES;
                if (model.isRequired) {
                    // 必选项一定校验非空，自动添加非空校验
                    NSMutableArray *mArr = [NSMutableArray arrayWithArray:model.cpnRule.validators];
                    [mArr addObject:@"IMSFormModelNotEmptyValidator"];
                    mArr = [mArr valueForKeyPath:@"@distinctUnionOfObjects.self"]; //去重
                    model.cpnRule.validators = mArr;
                } else {
                    Class cls = NSClassFromString(@"IMSFormModelNotEmptyValidator");
                    SEL sel = NSSelectorFromString(@"validateFormModel:");
                    NSError *emptyError = [self callValidatorWithClass:cls selector:sel formModel:model];
                    if (emptyError) {
                        executeValidate = NO;
                    }
                }
                if (executeValidate) {
                    for (id obj in model.cpnRule.validators) {
                        if (error) {
                            break;
                        }

                        if ([obj isKindOfClass:[IMSFormModelValidator class]]) {
                            IMSFormModelValidator *validator = (IMSFormModelValidator *)obj;
                            Class cls = NSClassFromString(validator.className);
                            SEL sel = NSSelectorFromString([NSMutableString stringWithFormat:@"%@:", validator.selectorName]);
                            error = [self callValidatorWithClass:cls selector:sel formModel:model];
                            if (error) {
                                NSLog(@"%@: %@", @"Verification failed".ims_localizable, error.localizedDescription);
                                error = validator.failure.message ? [NSError errorWithDomain:@"IMSFormModelValidatorError" code:-999 userInfo:@{ NSLocalizedDescriptionKey: validator.failure.message }] : error;
                                return error;
                            }
                        } else if ([obj isKindOfClass:[NSString class]]) {
                            Class cls = NSClassFromString(obj);
                            SEL sel = NSSelectorFromString(@"validateFormModel:");
                            error = [self callValidatorWithClass:cls selector:sel formModel:model];
                            if (error) {
                                NSLog(@"%@: %@", @"Verification failed".ims_localizable, error.localizedDescription);
                                return error;
                            }
                        } else {
                        }
                    }
                }
            }
        }
    }
    return error;
}

#pragma mark - Private Methods

+ (NSError *)callValidatorWithClass:(Class)cls selector:(SEL)sel formModel:(IMSFormModel *)model
{
    NSError *error = nil;
    NSString *desc = nil;
    id obj = [[cls alloc] init];
    if (!desc && (!cls || !obj)) {
        desc = [NSString stringWithFormat:@"%@: %@", @"No validator found".ims_localizable, NSStringFromClass(cls)];
        error = [NSError errorWithDomain:@"IMSFormModelValidatorError" code:-999 userInfo:@{ NSLocalizedDescriptionKey: desc }];
    }
    // 尝试执行实例对象的方法
    if (!desc) {
        if ([obj respondsToSelector:sel]) {
            error = ((NSError * (*)(id, SEL, id))objc_msgSend)(obj, sel, model);
        }
        // 尝试执行类对象的方法
        else if ([cls respondsToSelector:sel]) {
            error = ((NSError * (*)(id, SEL, IMSFormModel *))objc_msgSend)(cls, sel, model);
        } else {
            desc = [NSString stringWithFormat:@"%@: %@", @"Unimplemented verification method".ims_localizable, NSStringFromSelector(sel)];
            error = [NSError errorWithDomain:@"IMSFormModelValidatorError" code:-999 userInfo:@{ NSLocalizedDescriptionKey: desc }];
        }
    }
    return error;
}

@end
