//
//  IMSFormMultiSelectCPNConfig.h
//  IMSForm
//
//  Created by cjf on 1/2/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormMultiSelectCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic, getter=isGroup) BOOL group; /**< 是否分组显示 */
@property (assign, nonatomic) NSInteger multipleLimit; /**< 最多选择数量, n 限制选择数量；0 不能选择/选择数量为零； -1 不限制选择数/无限大 */

/**
 子列表Cell类型
 
 @param selectItemType 0 Default/ 1 Custom
 */
@property (copy, nonatomic) NSString *selectItemType;

@end

NS_ASSUME_NONNULL_END
