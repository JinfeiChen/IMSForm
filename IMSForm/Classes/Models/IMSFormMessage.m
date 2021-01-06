//
//  IMSFormMessage.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormMessage.h"

@implementation IMSFormMessageStyle

+ (instancetype)defaultStyle
{
    IMSFormMessageStyle *style = [[IMSFormMessageStyle alloc] init];
    
    style.titleFontSize = 16;
    style.titleFontHexColor = @"0x252D34";
    
    return style;
}

@end

@implementation IMSFormMessage

- (instancetype)init
{
    if (self = [super init]) {
        _type = IMSFormMessageType_Info;
    }
    return self;
}

#pragma mark - Getters

- (IMSFormMessageStyle *)style
{
    if (!_style) {
        _style = [IMSFormMessageStyle defaultStyle];
    }
    return _style;
}

@end
