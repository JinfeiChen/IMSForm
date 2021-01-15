//
//  IMSPopupSingleSelectContactModel.m
//  Raptor
//
//  Created by cjf on 18/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupSingleSelectContactModel.h"

@implementation IMSPopupSingleSelectContactModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"role": @[@"role", @"Role"],
        @"info": @[@"info", @"Info"],
        @"name": @[@"name", @"Name"],
        @"phone": @[@"phone", @"Phone"],
        @"value": @[@"name", @"Name"]
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        @"childArray" : [IMSPopupSingleSelectContactModel class]
    };
}

@end
