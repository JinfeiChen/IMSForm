//
//  IMSFormPhoneModel.m
//  IMSForm
//
//  Created by cjf on 28/1/2021.
//

#import "IMSFormPhoneModel.h"

@implementation IMSFormPhoneModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormPhoneCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormPhoneCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
