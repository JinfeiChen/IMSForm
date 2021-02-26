//
//  IMSPopupSingleSelectLocationModel.m
//  IMSForm
//
//  Created by cjf on 26/2/2021.
//

#import "IMSPopupSingleSelectLocationModel.h"

@implementation IMSPopupSingleSelectLocationModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
//        @"role": @[@"role", @"Role"]
    };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    dic[@"label"] = _Name;
    return YES;
}

//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    // value should be Class or Class name.
//    return @{
//        @"childArray" : [IMSPopupSingleSelectContactModel class]
//    };
//}

@end
