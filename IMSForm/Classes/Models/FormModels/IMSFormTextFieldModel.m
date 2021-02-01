//
//  IMSFormTextFieldModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormTextFieldModel.h"

@implementation IMSFormTextFieldModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormTextFieldCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormTextFieldCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
