//
//  IMSFormDateTimeRangeCPNConfig.h
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

/**
 Example:
 
 "cpnConfig" : {
     "datePickerType" : "datetime",
     "startPlaceholder" : "Start Date",
     "endPlaceholder" : "End Date"
 }
 */

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormDateTimeRangeCPNConfig : IMSFormCPNConfig

@property (nonatomic, assign) long minDate; // minDate 表示自今天往前/后推n天作为日历控件的最小日期，往前设置为负数，往后设置为正数，通常设置为负数
@property (nonatomic, assign) long maxDate; // maxDate 表示自今天往前/后推n天作为日历控件的最大日期，往前设置为负数，往后设置为正数，通常设置为正数
@property (nonatomic, strong) IMSFormDateTimeType datePickerType; /**< 模式 */

@property (copy, nonatomic) NSString *startPlaceholder; /**< default "Start Date" */
@property (copy, nonatomic) NSString *endPlaceholder; /**< default "End Date" */

@end

NS_ASSUME_NONNULL_END
