//
//  IMSFormCPNStyle.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormCPNStyle.h"

#define kIMSFormCellContentInsetTop 12.0
#define kIMSFormCellContentInsetLeft 15.0
#define kIMSFormCellContentInsetBottom 10.0
#define kIMSFormCellContentInsetRight 15.0

@implementation IMSFormCPNStyle

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *top = dic[@"contentInsetTop"] ? : @(kIMSFormCellContentInsetTop);
    NSNumber *left = dic[@"contentInsetLeft"] ? : @(kIMSFormCellContentInsetLeft);
    NSNumber *bottom = dic[@"contentInsetBottom"] ? : @(kIMSFormCellContentInsetBottom);
    NSNumber *right = dic[@"contentInsetRight"] ? : @(kIMSFormCellContentInsetRight);
    _contentInset = UIEdgeInsetsMake([top floatValue], [left floatValue], [bottom floatValue], [right floatValue]);
    return YES;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    dic[@"contentInsetTop"] = @(_contentInset.top);
    dic[@"contentInsetLeft"] = @(_contentInset.left);
    dic[@"contentInsetBottom"] = @(_contentInset.bottom);
    dic[@"contentInsetRight"] = @(_contentInset.right);
    return YES;
}

- (instancetype)init
{
    if (self = [super init]) {
        _layout = IMSFormLayoutType_Vertical;
        
        _titleHexColor = @"0x252D34";
        _titleFontSize = 14;
        
        _infoHexColor = @"0x9FA2A8";
        _infoFontSize = 12;
        
        _backgroundHexColor = @"0xF9F9F9";
        
        _spacing = 10.0;
        _contentInset = UIEdgeInsetsMake(kIMSFormCellContentInsetTop, kIMSFormCellContentInsetLeft, kIMSFormCellContentInsetBottom, kIMSFormCellContentInsetRight);
        
//        _tintHexColor = @"0xFFC24B";
    }
    return self;
}

+ (instancetype)defaultStyle
{
    IMSFormCPNStyle *style = [[IMSFormCPNStyle alloc] init];
    
    style.titleHexColor = @"0x252D34";
    style.titleFontSize = 14;
    
    style.infoHexColor = @"0x9FA2A8";
    style.infoFontSize = 12;
    
    style.backgroundHexColor = @"0xF9F9F9";
    
    style.spacing = 10.0;
    style.contentInset = UIEdgeInsetsMake(kIMSFormCellContentInsetTop, kIMSFormCellContentInsetLeft, kIMSFormCellContentInsetBottom, kIMSFormCellContentInsetRight);
    
    return style;
}

- (NSString *)tintHexColor
{
    // 获取自定义的全局表单主题色
    NSString *globalHexColor = [NSBundle mainBundle].infoDictionary[kIMSFormGlobalTintColorKey];
    return (_tintHexColor ? : globalHexColor) ? : kIMSFormDefaultTintHexColor;
}

@end
