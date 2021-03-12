//
//  IMSFormTextFieldCPNConfig.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormTextFieldCPNConfig : IMSFormCPNConfig

@property (copy, nonatomic) IMSFormTextType textType; /**< 文本输入类型限制, e.g. phone/email/url... */
@property (assign, nonatomic) NSInteger lengthLimit; /**< 文本最大输入长度限制, default 100 */
@property (assign, nonatomic) NSInteger precision; /**< 小数点精确度(小数点位数), default 2 */

@property (copy, nonatomic) NSString *unit; /**< 符号，默认为后置符号（等同于suffixUnit），设置后suffixUnit将失效 */
@property (copy, nonatomic) NSString *prefixUnit; /**< 前置符号, e.g. $ */
@property (copy, nonatomic) NSString *suffixUnit; /**< 后置符号, e.g. % */

@property (assign, nonatomic) BOOL localize; /**< 是否允许输入多语言文字 */
@property (strong, nonatomic) NSArray *localizeDatasource; /**< [{"en-US":""},{"zh-Hant":""},...]] */

@end

NS_ASSUME_NONNULL_END
