//
//  IMSFormDateTimeCPNConfig.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormDateTimeCPNConfig : IMSFormCPNConfig
@property (nonatomic, assign) long minDate;
@property (nonatomic, assign) long maxDate;
@property (nonatomic, strong) IMSFormDateTimeType datePickerType; /**< 模式 */
@end

NS_ASSUME_NONNULL_END
