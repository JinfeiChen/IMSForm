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

/**
 基础计算 截取指定小数位数 时间耗时较少
 */
+ (NSString *)getRoundFloat:(double)floatNumber withPrecisionNum:(NSInteger)precision
{
    // 0.123456789 精度2 => 0.12
    
    //core foundation 的当前确切时间
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    // 精度要求为2，算出 10的2次方，也就是100，让小数点右移两位，让原始小数扩大100倍
    double fact = pow(10,precision); // face = 100
    // 让小数扩大100倍，四舍五入后面的位数，再缩小100倍，这样成功的进行指定精度的四舍五入
    double result = round(fact * floatNumber) / fact; // result = 0.12
    // 组合成字符串 @"%.3f"   想要打印百分号%字符串 需要在前面加一个百分号 表示不转译
    NSString *proString = [NSString stringWithFormat:@"%%.%ldf",(long)precision]; //proString = @"%.2f"
    // 默认会显示6位 多余的n补0，所以需要指定显示多少小数位  @"%.2f" 0.123000
    NSString *resultString = [NSString stringWithFormat:proString,result];
    
    // time实际上是一个double
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"time cost: %0.6f", end - start);
    
    return resultString;
}

@end
