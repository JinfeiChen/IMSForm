//
//  IMSFormPhoneCPNConfig.h
//  IMSForm
//
//  Created by cjf on 28/1/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormPhoneCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic) NSInteger lengthLimit; /**< 文本最大输入长度限制, default 100 */
@property (assign, nonatomic) CGFloat min; /**< 最小值, e.g. 0.0 */
@property (assign, nonatomic) CGFloat max; /**< 最大值, e.g. 10.0 */
@property (assign, nonatomic) NSInteger precision; /**< 小数点精确度(小数点位数), default 2 */
@property (copy, nonatomic) NSString *prefixUnit; /**< 前置符号, e.g. $ */
@property (copy, nonatomic) NSString *suffixUnit; /**< 后置符号, e.g. % */

@end

NS_ASSUME_NONNULL_END
