//
//  IMSFormImageModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormImageModel.h"

@implementation IMSFormImageModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormImagesCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormImagesCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
