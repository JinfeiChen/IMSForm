//
//  IMSFormComponentConfig.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <IMSForm/IMSFormObject.h>

#import <IMSForm/IMSFormType.h> 

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormComponentConfig : IMSFormObject

#pragma mark - Select

@property (assign, nonatomic, getter=isMultiple) BOOL multiple; /**< 是否多选 */
@property (assign, nonatomic) NSInteger multipleLimit; /**< 最多选择数量, default 100 */

#pragma mark - TextField

@property (copy, nonatomic) IMSFormTextType textType; /**< 文本输入类型限制, e.g. phone/email/url... */
@property (assign, nonatomic) NSInteger lengthLimit; /**< 文本最大输入长度限制, default 100 */
@property (assign, nonatomic) NSInteger precision; /**< 小数点精确度(小数点位数), default 2 */
@property (copy, nonatomic) NSString *prefixUnit; /**< 前置符号, e.g. $ */
@property (copy, nonatomic) NSString *suffixUnit; /**< 后置符号, e.g. % */

#pragma mark - TextView

@property (assign, nonatomic) NSInteger maxRowsLimit; /**< 文本最大行数输入限制 */

#pragma mark - Switch

#pragma mark - Number

@property (assign, nonatomic) CGFloat min; /**< 最小值, e.g. 0.0 */
@property (assign, nonatomic) CGFloat max; /**< 最大值, e.g. 10.0 */
@property (assign, nonatomic) CGFloat increment; /**< 增量, default 1.0 */

#pragma mark - Range

@property (copy, nonatomic) NSString *minPlaceholder; /**< 最小值占位文本 */
@property (copy, nonatomic) NSString *maxPlaceholder; /**< 最大值占位文本 */

#pragma mark - Date

@property (nonatomic, assign) UIDatePickerMode datePickerMode; /**< 模式 */
@property (nonatomic, copy) NSString *dateFormat; /**< 日期格式，e.g. yyyy-MM-dd, MM/dd */

@end

NS_ASSUME_NONNULL_END
