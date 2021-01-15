//
//  DatePickerView.h
//
//  Created by longli on 2019/7/2.
//

#import "BasePickerView.h"
#import "NSDate+PickerView.h"

NS_ASSUME_NONNULL_BEGIN
/// 弹出日期类型
typedef NS_ENUM(NSInteger, PVDatePickerMode) {
    // --- 以下4种是系统自带的样式 ---
    // UIDatePickerModeTime
    PVDatePickerModeTime,              // HH:mm
    // UIDatePickerModeDate
    PVDatePickerModeDate,              // yyyy-MM-dd
    // UIDatePickerModeDateAndTime
    PVDatePickerModeDateAndTime,       // yyyy-MM-dd HH:mm
    // UIDatePickerModeCountDownTimer
    PVDatePickerModeCountDownTimer,    // HH:mm
    // --- 以下7种是自定义样式 ---
    // 年月日时分
    PVDatePickerModeYMDHM,      // yyyy-MM-dd HH:mm
    // 年月日时分秒
    PVDatePickerModeYMDHMS,      // yyyy-MM-dd HH:mm:ss
    // 月日时分
    PVDatePickerModeMDHM,       // MM-dd HH:mm
    // 年月日
    PVDatePickerModeYMD,        // yyyy-MM-dd
    // 年月
    PVDatePickerModeYM,         // yyyy-MM
    // 年
    PVDatePickerModeY,          // yyyy
    // 月日
    PVDatePickerModeMD,         // MM-dd
    // 时分
    PVDatePickerModeHM          // HH:mm
};

typedef void(^PVDateResultBlock)(NSString *selectValue);
typedef void(^PVDateCancelBlock)(void);
@interface DatePickerView : BasePickerView

/**
 *  1.显示时间选择器
 *
 *  @param title            标题
 *  @param dateType         日期显示类型
 *  @param defaultSelValue  默认选中的时间（值为空/值格式错误时，默认就选中现在的时间）
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(PVDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                    resultBlock:(PVDateResultBlock)resultBlock;

/**
 *  2.显示时间选择器（支持 设置自动选择 和 自定义主题颜色）
 *
 *  @param title            标题
 *  @param dateType         日期显示类型
 *  @param defaultSelValue  默认选中的时间（值为空/值格式错误时，默认就选中现在的时间）
 *  @param minDate          最小时间，可为空（请使用 NSDate+PVPickerView 分类中和显示类型格式对应的方法创建 minDate）
 *  @param maxDate          最大时间，可为空（请使用 NSDate+PVPickerView 分类中和显示类型格式对应的方法创建 maxDate）
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(PVDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(PVDateResultBlock)resultBlock;

/**
 *  3.显示时间选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param title            标题
 *  @param dateType         日期显示类型
 *  @param defaultSelValue  默认选中的时间（值为空/值格式错误时，默认就选中现在的时间）
 *  @param minDate          最小时间，可为空（请使用 NSDate+PVPickerView 分类中和显示类型格式对应的方法创建 minDate）
 *  @param maxDate          最大时间，可为空（请使用 NSDate+PVPickerView 分类中和显示类型格式对应的方法创建 maxDate）
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param themeColor       自定义主题颜色
 *  @param resultBlock      选择结果的回调
 *  @param cancelBlock      取消选择的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(PVDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(PVDateResultBlock)resultBlock
                    cancelBlock:(PVDateCancelBlock)cancelBlock;
@end

NS_ASSUME_NONNULL_END
