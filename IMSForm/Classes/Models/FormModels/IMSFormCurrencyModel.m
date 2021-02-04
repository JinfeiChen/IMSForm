//
//  IMSFormCurrencyModel.m
//  IMSForm
//
//  Created by cjf on 22/1/2021.
//

#import "IMSFormCurrencyModel.h"

@implementation IMSFormCurrencyModel

- (instancetype)init
{
    if (self = [super init]) {
        self.value = @"0";
    }
    return self;
}

@synthesize cpnConfig = _cpnConfig;

- (IMSFormCurrencyCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormCurrencyCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
