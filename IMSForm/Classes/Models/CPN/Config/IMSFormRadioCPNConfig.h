//
//  IMSFormRadioCPNConfig.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import <IMSForm/IMSFormCPNConfig.h>
#import <IMSForm/IMSFormSelect.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormRadioCPNConfig : IMSFormCPNConfig
@property (nonatomic, assign) BOOL deselect;// 是否取消选择； 默认为no，不可以取消
@end

NS_ASSUME_NONNULL_END
