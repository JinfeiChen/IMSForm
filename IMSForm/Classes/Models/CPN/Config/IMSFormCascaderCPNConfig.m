//
//  IMSFormCascaderCPNConfig.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import "IMSFormCascaderCPNConfig.h"

@implementation IMSFormCascaderCPNConfig

- (instancetype)init {
    if (self = [super init]) {
        _isMultiple = YES;
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        @"dataSource" : [IMSFormSelect class]
    };
}

@end
