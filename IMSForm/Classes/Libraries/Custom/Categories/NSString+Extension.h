//
//  NSString+Extension.h
//  Pods
//
//  Created by cjf on 5/1/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

// convert hex-string to integer value
+ (int)intRGBWithHex:(NSString *)hexString;
// convert uicolor to hex-string value
+ (NSString *)stringHexFromColor:(UIColor *)color;

/**
 基础计算-截取指定小数位数(时间耗时较少)
 
 @param floatNumber 浮点小数
 @param precision 小数点精确位数
 @return NSString
 */
+ (NSString *)getRoundFloat:(double)floatNumber withPrecisionNum:(NSInteger)precision;

// 读取本地化文字
- (NSString *)ims_localizable;

@end

NS_ASSUME_NONNULL_END
