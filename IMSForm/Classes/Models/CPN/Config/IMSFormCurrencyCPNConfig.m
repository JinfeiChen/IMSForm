//
//  IMSFormCurrencyCPNConfig.m
//  IMSForm
//
//  Created by cjf on 22/1/2021.
//

#import "IMSFormCurrencyCPNConfig.h"

@implementation IMSFormCurrencyCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _lengthLimit = 100;
        _precision = 2;
        _min = 0;
        _max = 10000000000000.0;
    }
    return self;
}

@end
