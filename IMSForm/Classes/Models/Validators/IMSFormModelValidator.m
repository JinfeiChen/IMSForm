//
//  IMSFormModelValidator.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormModelValidator.h"

@implementation IMSFormModelValidator

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"className" : @[@"class"],
        @"selectorName" : @[@"selector"]
    };
}

- (BOOL)validateFormModel:(IMSFormModel *)formModel
{
    // 请在子类中实现具体的检验
    return YES;
}

- (BOOL)validateFormModel:(IMSFormModel *)formModel keyPath:(NSString *)keyPath
{
    // 请在子类中实现具体的检验
    return YES;
}

@end
