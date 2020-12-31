//
//  IMSFormValidateManager.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <Foundation/Foundation.h>

#import <IMSForm/IMSFormModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormValidateManager : NSObject

/**
 正则校验

 @param value 校验的字符串
 @param regex 校验的正则表达式
 @return BOOL
 */
+ (BOOL)validate:(NSString *)value withRegex:(NSString *)regex;

/**
 手机号校验

 @param value 校验的字符串
 @return BOOL
 */
+ (BOOL)isMobile:(NSString *)value;

/**
 非空校验

 @param value 校验的字符串
 @return BOOL 为空返回YES
 */
+ (BOOL)isEmpty:(NSString *)value;

/**
 数据源校验

 @param dataArray 表单的数据源
 @return 全部校验通过返回YES，否则返回NO。
 */
+ (BOOL)validateFormDataArray:(NSArray<IMSFormModel *> *)dataArray;

@end

NS_ASSUME_NONNULL_END
