//
//  IMSFormNumberModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormNumberModel.h"

@implementation IMSFormNumberModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormNumberCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormNumberCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
