//
//  IMSFormValidateManager.h
//  Pods
//  校验类
//  开发者可创建子类，实现自定义的校验方法（Required规则: 有且仅有一个参数，并且参数类型为IMSFormModel）
//
//  Created by cjf on 31/12/2020.
//

#import <Foundation/Foundation.h>

#import <IMSForm/IMSFormType.h>
#import <IMSForm/IMSFormModel.h>
#import <IMSForm/IMSDropHUD.h>
#import <IMSForm/IMSFormManager+HUD.h>

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
 Email校验

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
 URL校验
 注意：这里校验忽略了url长度限制，有特殊要求可使用严格的正则表达式配合validate:withRegex:使用
 
 @param value 校验的字符串
 @return BOOL
 */
+ (BOOL)isURL:(NSString *)value;

/**
 数据源校验

 @param dataArray 表单的数据源
 @return NSError 全部校验通过返回nil，否则返回error。
 */
+ (NSError *)validateFormDataSource:(NSArray<IMSFormModel *> *)dataArray;

@end

NS_ASSUME_NONNULL_END
