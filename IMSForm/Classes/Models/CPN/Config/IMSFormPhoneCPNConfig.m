//
//  IMSFormPhoneCPNConfig.m
//  IMSForm
//
//  Created by cjf on 28/1/2021.
//

#import "IMSFormPhoneCPNConfig.h"

@implementation IMSFormPhoneCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _lengthLimit = 100;
        _precision = 2;
        _min = 0;
        _max = 10000000000;
    }
    return self;
}

@end
