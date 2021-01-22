//
//  IMSFormSliderModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormSliderModel.h"

@implementation IMSFormSliderModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormSliderCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormSliderCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
