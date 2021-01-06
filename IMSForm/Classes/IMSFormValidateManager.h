//
//  IMSFormValidateManager.h
//  Pods
//  校验类
//  开发者可创建子类，实现自定义的校验方法（Required规则: 有且仅有一个参数，并且参数类型为IMSFormModel）
//
//  Created by cjf on 31/12/2020.
//

#import <Foundation/Foundation.h>

#import <IMSForm/IMSFormModel.h>
#import <IMSForm/IMSDropHUD.h>

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
 空字符校验

 @param value 校验的字符串
 @return BOOL 为空返回YES
 */
+ (BOOL)isEmpty:(NSString *)value;
// 非空校验
+ (BOOL)isNotEmpty:(NSString *)value;

/**
 邮箱校验

 @param value 校验的字符串
 @return BOOL
 */
+ (BOOL)isEmail:(NSString *)value;

/**
 数字校验
 
 @param value 校验的字符串
 @return BOOL
 */
+ (BOOL)isNumber:(NSString *)value;

/**
 浮点数字校验
 
 @param value 校验的字符串
 @return BOOL
 */
+ (BOOL)isFloatNumber:(NSString *)value;

/**
 数据源校验

 @param dataArray 表单的数据源
 @return BOOL 全部校验通过返回YES，否则返回NO。
 */
+ (BOOL)validateFormDataSource:(NSArray<IMSFormModel *> *)dataArray;

@end

NS_ASSUME_NONNULL_END
