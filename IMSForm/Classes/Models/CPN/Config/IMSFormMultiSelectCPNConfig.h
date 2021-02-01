//
//  IMSFormMultiSelectCPNConfig.h
//  IMSForm
//
//  Created by cjf on 1/2/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormMultiSelectCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic) NSInteger multipleLimit; /**< 最多选择数量, default 100, 当isMultiple=NO时，multipleLimit不可变，始终为1 */

/**
 子列表Cell类型
 
 @param selectItemType 0 Default/ 1 Custom
 */
@property (copy, nonatomic) NSString *selectItemType;

@end

NS_ASSUME_NONNULL_END
