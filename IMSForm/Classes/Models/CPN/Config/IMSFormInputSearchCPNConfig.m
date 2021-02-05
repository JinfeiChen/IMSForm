//
//  IMSFormInputSearchCPNConfig.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormInputSearchCPNConfig.h"

@implementation IMSFormInputSearchCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _textType = IMSFormTextType_Default;
        _lengthLimit = 100;
        _selectItemType = @"default";
    }
    return self;
}

@end
