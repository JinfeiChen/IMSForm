//
//  IMSFormSelect.m
//  IMSForm
//
//  Created by cjf on 11/1/2021.
//

#import "IMSFormSelect.h"

@implementation IMSFormSelect

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        @"child" : [IMSFormSelect class]
    };
}

@end
