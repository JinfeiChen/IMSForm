//
//  IMSFormFileCPNConfig.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormFileCPNConfig.h"

@implementation IMSFormFileCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _maxFilesLimit = 20;
        _fileUploadSelectorString = @"IMSForm_UploadFile:completed:";
    }
    return self;
}

@end
