//
//  IMSFormMultiTextFieldModel.m
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import "IMSFormMultiTextFieldModel.h"

@implementation IMSFormMultiTextFieldModel

#pragma mark - Setters

- (void)setValueList:(NSMutableArray *)valueList
{
    [super setValueList:valueList];
    
    
}

@synthesize cpnConfig = _cpnConfig;

- (IMSFormMultiTextFieldCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormMultiTextFieldCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
