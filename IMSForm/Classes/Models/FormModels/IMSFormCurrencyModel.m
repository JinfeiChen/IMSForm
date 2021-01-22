//
//  IMSFormCurrencyModel.m
//  IMSForm
//
//  Created by cjf on 22/1/2021.
//

#import "IMSFormCurrencyModel.h"

@implementation IMSFormCurrencyModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormCurrencyCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormCurrencyCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
