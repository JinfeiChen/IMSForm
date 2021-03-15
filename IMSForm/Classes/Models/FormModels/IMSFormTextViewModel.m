//
//  IMSFormTextViewModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormTextViewModel.h"

@implementation IMSFormTextViewModel

#pragma mark - Getters

@synthesize cpnConfig = _cpnConfig;

- (IMSFormTextViewCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormTextViewCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
