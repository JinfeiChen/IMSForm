//
//  IMSFormSelectCPNConfig.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSForm.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormSelectCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic, getter=isMultiple) BOOL multiple; /**< 是否多选, default NO */
@property (assign, nonatomic) NSInteger multipleLimit; /**< 最多选择数量, default 100, 当isMultiple=NO时，multipleLimit不可变，始终为1 */

/**
 子列表Cell类型
 
 A. multiple YES : 0 Default/ 1 Custom
 B. multiple NO : 0 Default/ 1 Contact/ 2 Custom
 */
@property (copy, nonatomic) NSString *selectItemType;
@property (strong, nonatomic) NSArray *selectDataSource; /**< 数据列表 */

@end

NS_ASSUME_NONNULL_END
