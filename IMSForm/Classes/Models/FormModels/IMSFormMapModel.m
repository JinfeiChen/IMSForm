//
//  IMSFormMapModel.m
//  IMSForm
//
//  Created by cjf on 26/2/2021.
//

#import "IMSFormMapModel.h"

@implementation IMSFormMapModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormMapCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormMapCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
