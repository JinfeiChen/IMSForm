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

@end

NS_ASSUME_NONNULL_END
