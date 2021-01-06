//
//  IMSFormComponentStyle.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormComponentStyle.h"

@implementation IMSFormComponentStyle

- (instancetype)init
{
    if (self = [super init]) {
        _layout = IMSFormLayoutType_Vertical;
    }
    return self;
}

+ (instancetype)defaultStyle
{
    IMSFormComponentStyle *style = [[IMSFormComponentStyle alloc] init];
    
    style.titleHexColor = @"0x252D34";
    style.titleFontSize = 16;
    
    style.infoHexColor = @"0x9FA2A8";
    style.infoFontSize = 12;
    
    style.backgroundHexColor = @"0xF9F9F9";
    
    style.spacing = 10.0;
    style.contentInset = UIEdgeInsetsMake(12, 15, 10, 15);
    
    return style;
}



@end
