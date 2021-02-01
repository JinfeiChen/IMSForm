//
//  IMSFormRadioModel.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import "IMSFormRadioModel.h"

@implementation IMSFormRadioModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormRadioCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormRadioCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
