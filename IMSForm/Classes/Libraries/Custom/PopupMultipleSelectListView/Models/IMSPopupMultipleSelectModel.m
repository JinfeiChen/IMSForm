//
//  IMSPopupMultipleSelectModel.m
//  Raptor
//
//  Created by cjf on 22/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupMultipleSelectModel.h"

@implementation IMSPopupMultipleSelectModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
        @"title": @[@"title", @"Title"]
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        @"child": [IMSPopupMultipleSelectModel class]
    };
}

@end
