//
//  IMSFormCascaderCPNConfig.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import <IMSForm/IMSForm.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormCascaderCPNConfig : IMSFormCPNConfig
@property (nonatomic, assign) BOOL isMultiple;// 是否多项，默认多选
@property (nonatomic, assign) NSInteger maxCount;//最大限制数量
@property (nonatomic, assign) NSInteger didSelectedCount;// 已经选择的数量

@end

NS_ASSUME_NONNULL_END
