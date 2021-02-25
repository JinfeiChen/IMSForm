//
//  IMSFormImageControlsCPNConfig.m
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import "IMSFormImageControlsCPNConfig.h"

@implementation IMSFormImageControlsCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _maxImagesLimit = 100;
        _rowImages = 4;
    }
    return self;
}

@end
