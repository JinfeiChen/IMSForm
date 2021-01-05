//
//  IMSFormComponentRule.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormComponentRule.h"

@implementation IMSFormValidator

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"className" : @[@"class"],
        @"selectorName" : @[@"selector"]
    };
}

@end

@implementation IMSFormComponentRule

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        @"validators" : [IMSFormValidator class]
    };
}

#pragma mark - Getters

- (IMSFormMessage *)message
{
    if (!_message) {
        _message = [[IMSFormMessage alloc] init];
    }
    return _message;
}

- (IMSFormTrigger)trigger
{
    if (!_trigger) {
        _trigger = IMSFormTrigger_Change;
    }
    return _trigger;
}

@end
