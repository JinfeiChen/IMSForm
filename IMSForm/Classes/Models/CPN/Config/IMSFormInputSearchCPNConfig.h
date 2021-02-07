//
//  IMSFormInputSearchCPNConfig.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormInputSearchCPNConfig : IMSFormCPNConfig

@property (copy, nonatomic) IMSFormTextType textType; /**< 文本输入类型限制, e.g. phone/email/url... */
@property (assign, nonatomic) NSInteger lengthLimit; /**< 文本最大输入长度限制, default 100 */

/**
 子列表Cell类型
 
 @pram selectItemType 0 Default/ 1 Contact/ 2 Custom
 */
@property (copy, nonatomic) NSString *selectItemType;

@property (copy, nonatomic) NSString *searchSelectorString; /**< 搜索方法名，需要在外界实现具体 */

@end

NS_ASSUME_NONNULL_END
