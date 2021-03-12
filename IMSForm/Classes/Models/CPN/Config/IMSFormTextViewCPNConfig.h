//
//  IMSFormTextViewCPNConfig.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormTextViewCPNConfig : IMSFormCPNConfig

@property (copy, nonatomic) IMSFormTextType textType; /**< 文本输入类型限制, e.g. phone/email/url... */
@property (assign, nonatomic) NSInteger lengthLimit; /**< 文本最大输入长度限制, default 100 */
@property (assign, nonatomic) NSInteger maxRowsLimit; /**< 文本最大行数输入限制 */

@property (assign, nonatomic) BOOL localize; /**< 是否允许输入多语言文字 */
@property (strong, nonatomic) NSArray *localizeDatasource; /**< [{"en-US":""},{"zh-Hant":""},...]] */

@end

NS_ASSUME_NONNULL_END
