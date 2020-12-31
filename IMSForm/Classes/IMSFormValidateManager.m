//
//  IMSFormValidateManager.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormValidateManager.h"

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

+ (BOOL)validateFormDataArray:(NSArray<IMSFormModel *> *)dataArray
{
    for (IMSFormModel * _Nonnull obj in dataArray) {
        if (obj.cpnRule) {
            for (IMSFormModelValidateBlock block in obj.cpnRule.validators) {
                if (!block(obj)) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

@end
