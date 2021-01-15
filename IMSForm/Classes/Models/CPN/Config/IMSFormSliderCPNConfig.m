//
//  IMSFormSliderCPNConfig.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormSliderCPNConfig.h"

@implementation IMSFormSliderCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _precision = 0;
        _min = 0.0;
        _max = 100000.0;
    }
    return self;
}

@end
