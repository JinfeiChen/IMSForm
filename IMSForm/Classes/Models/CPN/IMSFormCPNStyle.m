//
//  IMSFormCPNStyle.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormCPNStyle.h"

@implementation IMSFormCPNStyle

- (instancetype)init
{
    if (self = [super init]) {
        _layout = IMSFormLayoutType_Vertical;
        
        _titleHexColor = @"0x252D34";
        _titleFontSize = 16;
        
        _infoHexColor = @"0x9FA2A8";
        _infoFontSize = 12;
        
        _backgroundHexColor = @"0xF9F9F9";
        
        _spacing = 10.0;
        _contentInset = UIEdgeInsetsMake(12, 15, 10, 15);
        
        _tintHexColor = @"0xFFC24B";
    }
    return self;
}

+ (instancetype)defaultStyle
{
    IMSFormCPNStyle *style = [[IMSFormCPNStyle alloc] init];
    
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
