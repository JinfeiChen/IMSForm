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

+ (BOOL)validateFormDataSource:(NSArray<IMSFormModel *> *)dataArray validator:(id)validator
{
    validator = validator ? : self;
    for (IMSFormModel * _Nonnull model in dataArray) {
        if (model.isRequired && model.isEditable && model.isVisible) {
            if (model.cpnRule) {
                for (NSString *funcName in model.cpnRule.validators) {
                    NSString *str = [NSMutableString stringWithFormat:@"%@:", funcName];
                    SEL sel = NSSelectorFromString(str);
                    if ([validator respondsToSelector:sel]) {
                        BOOL result = ((BOOL(*)(id, SEL, id))objc_msgSend)(validator, sel, model);
                        if (!result) {
                            NSLog(@"%@ 未通过 %@ 校验, value = %@", model.title, funcName, model.value);
                            return NO;
                        }
                    } else {
                        NSLog(@"未实现的校验方法");
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}

@end
