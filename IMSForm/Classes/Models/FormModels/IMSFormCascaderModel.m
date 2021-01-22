//
//  IMSFormCascaderModel.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import "IMSFormCascaderModel.h"

@implementation IMSFormCascaderModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormCascaderCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormCascaderCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
