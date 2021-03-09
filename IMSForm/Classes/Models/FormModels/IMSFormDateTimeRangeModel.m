//
//  IMSFormDateTimeRangeModel.m
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import "IMSFormDateTimeRangeModel.h"

@implementation IMSFormDateTimeRangeModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormDateTimeRangeCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormDateTimeRangeCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
