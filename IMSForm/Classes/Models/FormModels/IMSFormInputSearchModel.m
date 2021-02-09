//
//  IMSFormInputSearchModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormInputSearchModel.h"

@implementation IMSFormInputSearchModel

#pragma mark - Setters

- (void)setValueList:(NSMutableArray *)valueList
{
    [super setValueList:valueList];
    
    
}

#pragma mark - Getters

@synthesize cpnConfig = _cpnConfig;

- (IMSFormInputSearchCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormInputSearchCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
