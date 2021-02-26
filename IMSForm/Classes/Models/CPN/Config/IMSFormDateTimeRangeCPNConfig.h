//
//  IMSFormDateTimeRangeCPNConfig.h
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormDateTimeRangeCPNConfig : IMSFormCPNConfig

@property (nonatomic, assign) long minDate; // minDate 表示自今天往前/后推n天作为日历控件的最小日期，往前设置为负数，往后设置为正数，通常设置为负数
@property (nonatomic, assign) long maxDate; // maxDate 表示自今天往前/后推n天作为日历控件的最大日期，往前设置为负数，往后设置为正数，通常设置为正数
@property (nonatomic, strong) IMSFormDateTimeType datePickerType; /**< 模式 */

@end

NS_ASSUME_NONNULL_END
