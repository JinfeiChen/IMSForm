//
//  IMSFormSelectCPNConfig.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormSelectCPNConfig.h"

@implementation IMSFormSelectCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _multiple = NO;
        _multipleLimit = _multiple ? 100 : 1;
    }
    return self;
}

@end
