//
//  IMSFormRangeModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormRangeModel.h"

@implementation IMSFormRangeModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormRangeCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormRangeCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
