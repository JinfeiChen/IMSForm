//
//  IMSFormSelect.m
//  IMSForm
//
//  Created by cjf on 11/1/2021.
//

#import "IMSFormSelect.h"

@implementation IMSFormSelect

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"param" : @[@"id",@"Id",@"value"]
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        @"child" : [IMSFormSelect class]
    };
}

- (instancetype)init
{
    if (self = [super init]) {
        self.selected = NO;
        self.enable = YES;
    }
    return self;
}

@end
