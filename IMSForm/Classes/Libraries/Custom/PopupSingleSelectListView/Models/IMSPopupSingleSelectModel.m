//
//  IMSPopupSingleSelectModel.m
//  Raptor
//
//  Created by cjf on 18/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupSingleSelectModel.h"

@implementation IMSPopupSingleSelectModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"value": @[@"value", @"Value"],
        @"label": @[@"label", @"Label"],
        @"Name": @[@"name", @"Name"]
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        @"childArray" : [IMSPopupSingleSelectModel class]
    };
}

@end
