//
//  IMSFormSelectCPNConfig.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormSelectCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic, readonly) NSInteger multipleLimit; /**< 最多选择数量, default 始终为1 */

/**
 子列表Cell类型
 
 @pram selectItemType 0 Default/ 1 Contact/ 2 Custom
 */
@property (copy, nonatomic) NSString *selectItemType;

@end

NS_ASSUME_NONNULL_END
