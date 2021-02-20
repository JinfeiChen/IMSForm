//
//  IMSFormMultiSelectCPNConfig.m
//  IMSForm
//
//  Created by cjf on 1/2/2021.
//

#import "IMSFormMultiSelectCPNConfig.h"

@implementation IMSFormMultiSelectCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _multipleLimit = -1; // n 限制选择数量；0 不能选择/选择数量为零； -1 不限制选择数/无限大
    }
    return self;
}

@end
