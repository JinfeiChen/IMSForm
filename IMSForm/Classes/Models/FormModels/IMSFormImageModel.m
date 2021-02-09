//
//  IMSFormImageModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormImageModel.h"

@implementation IMSFormImageModel

#pragma mark - Setters

- (void)setValueList:(NSMutableArray *)valueList
{
    [super setValueList:valueList];
    
    
}

#pragma mark - Getters

@synthesize cpnConfig = _cpnConfig;

- (IMSFormImagesCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormImagesCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
