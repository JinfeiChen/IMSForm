//
//  IMSFormDateTimeModel.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import "IMSFormDateTimeModel.h"

@implementation IMSFormDateTimeModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormDateTimeCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormDateTimeCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
