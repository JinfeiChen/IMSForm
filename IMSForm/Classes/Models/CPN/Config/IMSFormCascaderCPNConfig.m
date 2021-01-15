//
//  IMSFormCascaderCPNConfig.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import "IMSFormCascaderCPNConfig.h"

@implementation IMSFormCascaderCPNConfig

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        @"selectDataSource" : [IMSFormSelect class]
    };
}

@end
