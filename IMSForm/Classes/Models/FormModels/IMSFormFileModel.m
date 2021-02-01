//
//  IMSFormFileModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormFileModel.h"

@implementation IMSFormFileModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormFileCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormFileCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
