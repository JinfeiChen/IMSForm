//
//  NSString+Extension.m
//  Pods
//
//  Created by cjf on 5/1/2021.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (int)intRGBWithHex:(NSString *)hexString
{
    if (!hexString || hexString.length == 0) {
        return 0;
    }
    unsigned int outVal;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&outVal];
    return outVal;
}

+ (NSString *)stringHexFromColor:(UIColor *)color
{
    if (!color) {
        return @"0x000000";
    }
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    NSString *hexString = [NSString stringWithFormat:@"%02X%02X%02X", (int)(red * 255), (int)(green * 255), (int)(blue * 255)];
    return hexString;
}

@end
