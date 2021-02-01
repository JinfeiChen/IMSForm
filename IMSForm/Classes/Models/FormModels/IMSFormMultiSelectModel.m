//
//  IMSFormMultiSelectModel.m
//  IMSForm
//
//  Created by cjf on 1/2/2021.
//

#import "IMSFormMultiSelectModel.h"

@implementation IMSFormMultiSelectModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormMultiSelectCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormMultiSelectCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
