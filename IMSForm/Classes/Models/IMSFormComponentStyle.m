//
//  IMSFormComponentStyle.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormComponentStyle.h"

@implementation IMSFormComponentStyle

- (instancetype)init
{
    if (self = [super init]) {
        _layout = IMSFormComponentLayout_Vertical;
    }
    return self;
}

+ (instancetype)defaultStyle
{
    return [[IMSFormComponentStyle alloc] init];
}

@end
