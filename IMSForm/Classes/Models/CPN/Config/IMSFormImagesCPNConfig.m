//
//  IMSFormImagesCPNConfig.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormImagesCPNConfig.h"

@implementation IMSFormImagesCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _maxImagesLimit = 20;
        _rowImages = 4;
        _imageUploadSelectorString = @"IMSForm_UploadImages:completed:";
    }
    return self;
}

@end
