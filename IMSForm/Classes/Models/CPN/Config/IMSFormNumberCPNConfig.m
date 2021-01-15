//
//  IMSFormNumberCPNConfig.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormNumberCPNConfig.h"

@implementation IMSFormNumberCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _precision = 0;
        _increment = 1.0;
        _min = 0.0;
        _max = 100000.0;
    }
    return self;
}

@end
