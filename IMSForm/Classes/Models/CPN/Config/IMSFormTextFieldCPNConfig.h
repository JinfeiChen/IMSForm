//
//  IMSFormTextFieldCPNConfig.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormCPNConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormTextFieldCPNConfig : IMSFormCPNConfig

@property (copy, nonatomic) IMSFormTextType textType; /**< 文本输入类型限制, e.g. phone/email/url... */
@property (assign, nonatomic) NSInteger lengthLimit; /**< 文本最大输入长度限制, default 100 */
@property (assign, nonatomic) NSInteger precision; /**< 小数点精确度(小数点位数), default 2 */
@property (copy, nonatomic) NSString *prefixUnit; /**< 前置符号, e.g. $ */
@property (copy, nonatomic) NSString *suffixUnit; /**< 后置符号, e.g. % */

@end

NS_ASSUME_NONNULL_END
