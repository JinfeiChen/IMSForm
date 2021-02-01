//
//  IMSFormSelectModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormSelectModel.h"

@implementation IMSFormSelectModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormSelectCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormSelectCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
