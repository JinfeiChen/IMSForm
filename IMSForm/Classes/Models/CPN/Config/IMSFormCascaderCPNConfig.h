//
//  IMSFormCascaderCPNConfig.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import <IMSForm/IMSFormCPNConfig.h>
#import <IMSForm/IMSFormSelect.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormCascaderCPNConfig : IMSFormCPNConfig
@property (nonatomic, assign) NSInteger maxCount;//最大限制数量
@property (nonatomic, assign) NSInteger didSelectedCount;// 已经选择的数量
@property (strong, nonatomic) NSArray *selectDataSource; /**< 数据列表 */
@end

NS_ASSUME_NONNULL_END
