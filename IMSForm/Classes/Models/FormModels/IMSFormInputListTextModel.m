//
//  IMSFormInputListTextModel.m
//  IMSForm
//
//  Created by cjf on 8/3/2021.
//

#import "IMSFormInputListTextModel.h"

@implementation IMSFormInputListTextModel

#pragma mark - Setters

- (void)setValueList:(NSMutableArray *)valueList
{
    [super setValueList:valueList];
}

#pragma mark - Getters

@synthesize cpnConfig = _cpnConfig;

- (IMSFormInputListTextCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormInputListTextCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
