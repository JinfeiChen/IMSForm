//
//  DatePickerView.m
//  unknownProjectName
//
//  Created by longli on 2019/7/2.
//  Copyright © 2019 ***** All rights reserved.
//

#import "DatePickerView.h"
#import "PickerViewMacro.h"

/// 时间选择器的类型
typedef NS_ENUM(NSInteger, PVDatePickerStyle) {
    PVDatePickerStyleSystem,   // 系统样式：使用 UIDatePicker 类
    PVDatePickerStyleCustom    // 自定义样式：使用 UIPickerView 类
};
@interface DatePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    // 记录 年、月、日、时、分 当前选择的位置
    NSInteger _yearIndex;
    NSInteger _monthIndex;
    NSInteger _dayIndex;
    NSInteger _hourIndex;
    NSInteger _minuteIndex;
    NSInteger _secondIndex;
    
    NSString *_title;
    UIDatePickerMode _datePickerMode;
    BOOL _isAutoSelect;      // 是否开启自动选择
    UIColor *_themeColor;
}
/** 时间选择器1 */
@property (nonatomic, strong) UIDatePicker *datePicker;
/** 时间选择器2 */
@property (nonatomic, strong) UIPickerView *pickerView;
/// 日期存储数组
@property(nonatomic, strong) NSArray *yearArr;
@property(nonatomic, strong) NSArray *monthArr;
@property(nonatomic, strong) NSArray *dayArr;
@property(nonatomic, strong) NSArray *hourArr;
@property(nonatomic, strong) NSArray *minuteArr;
@property(nonatomic, strong) NSArray *secondArr;
/** 显示类型 */
@property (nonatomic, assign) PVDatePickerMode showType;
/** 时间选择器的类型 */
@property (nonatomic, assign) PVDatePickerStyle style;
/** 限制最小日期 */
@property (nonatomic, strong) NSDate *minLimitDate;
/** 限制最大日期 */
@property (nonatomic, strong) NSDate *maxLimitDate;
/** 当前选择的日期 */
@property (nonatomic, strong) NSDate *selectDate;
/** 选择的日期的格式 */
@property (nonatomic, strong) NSString *selectDateFormatter;

/** 选中后的回调 */
@property (nonatomic, copy) PVDateResultBlock resultBlock;
/** 取消选择的回调 */
@property (nonatomic, copy) PVDateCancelBlock cancelBlock;
@end
@implementation DatePickerView


#pragma mark - 1.显示时间选择器
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(PVDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                    resultBlock:(PVDateResultBlock)resultBlock {
    [self showDatePickerWithTitle:title dateType:dateType defaultSelValue:defaultSelValue minDate:nil maxDate:nil isAutoSelect:NO themeColor:nil resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 2.显示时间选择器（支持 设置自动选择 和 自定义主题颜色）
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(PVDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(PVDateResultBlock)resultBlock {
    [self showDatePickerWithTitle:title dateType:dateType defaultSelValue:defaultSelValue minDate:minDate maxDate:maxDate isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:nil];
}

#pragma mark - 3.显示时间选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
+ (void)showDatePickerWithTitle:(NSString *)title
                       dateType:(PVDatePickerMode)dateType
                defaultSelValue:(NSString *)defaultSelValue
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate
                   isAutoSelect:(BOOL)isAutoSelect
                     themeColor:(UIColor *)themeColor
                    resultBlock:(PVDateResultBlock)resultBlock
                    cancelBlock:(PVDateCancelBlock)cancelBlock {
    DatePickerView *datePickerView = [[DatePickerView alloc]initWithTitle:title dateType:dateType defaultSelValue:defaultSelValue minDate:minDate maxDate:maxDate isAutoSelect:isAutoSelect themeColor:themeColor resultBlock:resultBlock cancelBlock:cancelBlock];
    [datePickerView showWithAnimation:YES];
}

#pragma mark - 初始化时间选择器
- (instancetype)initWithTitle:(NSString *)title
                     dateType:(PVDatePickerMode)dateType
              defaultSelValue:(NSString *)defaultSelValue
                      minDate:(NSDate *)minDate
                      maxDate:(NSDate *)maxDate
                 isAutoSelect:(BOOL)isAutoSelect
                   themeColor:(UIColor *)themeColor
                  resultBlock:(PVDateResultBlock)resultBlock
                  cancelBlock:(PVDateCancelBlock)cancelBlock {
    if (self = [super init]) {
        _title = title;
        _isAutoSelect = isAutoSelect;
        _themeColor = themeColor;
        _resultBlock = resultBlock;
        _cancelBlock = cancelBlock;
        self.showType = dateType;
        [self setupSelectDateFormatter:dateType];
        // 1.最小日期限制
        if (minDate) {
            self.minLimitDate = minDate;
        } else {
            if (self.showType == PVDatePickerModeTime || self.showType == PVDatePickerModeCountDownTimer || self.showType == PVDatePickerModeHM) {
                self.minLimitDate = [NSDate pv_setHour:0 minute:0];
            } else if (self.showType == PVDatePickerModeMDHM) {
                self.minLimitDate = [NSDate pv_setMonth:1 day:1 hour:0 minute:0];
            } else if (self.showType == PVDatePickerModeMD) {
                self.minLimitDate = [NSDate pv_setMonth:1 day:1];
            } else {
                self.minLimitDate = [NSDate distantPast]; // 遥远的过去的一个时间点
            }
        }
        // 2.最大日期限制
        if (maxDate) {
            self.maxLimitDate = maxDate;
        } else {
            if (self.showType == PVDatePickerModeTime || self.showType == PVDatePickerModeCountDownTimer || self.showType == PVDatePickerModeHM) {
                self.maxLimitDate = [NSDate pv_setHour:23 minute:59];
            } else if (self.showType == PVDatePickerModeMDHM) {
                self.maxLimitDate = [NSDate pv_setMonth:12 day:31 hour:23 minute:59];
            } else if (self.showType == PVDatePickerModeMD) {
                self.maxLimitDate = [NSDate pv_setMonth:12 day:31];
            } else {
                self.maxLimitDate = [NSDate distantFuture]; // 遥远的未来的一个时间点
            }
        }
        BOOL minMoreThanMax = [self.minLimitDate pv_compare:self.maxLimitDate format:self.selectDateFormatter] == NSOrderedDescending;
        NSAssert(!minMoreThanMax, @"最小日期不能大于最大日期！");
        if (minMoreThanMax) {
            // 如果最小日期大于了最大日期，就忽略两个值
            self.minLimitDate = [NSDate distantPast];
            self.maxLimitDate = [NSDate distantFuture];
        }
        
        // 3.默认选中的日期
        if (defaultSelValue && defaultSelValue.length > 0) {
            NSDate *defaultSelDate = [NSDate pv_getDate:defaultSelValue format:self.selectDateFormatter];
            if (!defaultSelDate) {
                NSAssert(defaultSelDate, @"参数格式错误！请检查形参 defaultSelValue 的格式");
                defaultSelDate = [NSDate date]; // 默认值参数格式错误时，重置/忽略默认值，防止在 Release 环境下崩溃！
            }
            if (self.showType == PVDatePickerModeTime || self.showType == PVDatePickerModeCountDownTimer || self.showType == PVDatePickerModeHM) {
                self.selectDate = [NSDate pv_setHour:defaultSelDate.pv_hour minute:defaultSelDate.pv_minute];
            } else if (self.showType == PVDatePickerModeMDHM) {
                self.selectDate = [NSDate pv_setMonth:defaultSelDate.pv_month day:defaultSelDate.pv_day hour:defaultSelDate.pv_hour minute:defaultSelDate.pv_minute];
            } else if (self.showType == PVDatePickerModeMD) {
                self.selectDate = [NSDate pv_setMonth:defaultSelDate.pv_month day:defaultSelDate.pv_day];
            } else {
                self.selectDate = defaultSelDate;
            }
        } else {
            // 不设置默认日期，就默认选中今天的日期
            self.selectDate = [NSDate date];
        }
        BOOL selectLessThanMin = [self.selectDate pv_compare:self.minLimitDate format:self.selectDateFormatter] == NSOrderedAscending;
        BOOL selectMoreThanMax = [self.selectDate pv_compare:self.maxLimitDate format:self.selectDateFormatter] == NSOrderedDescending;
        NSAssert(!selectLessThanMin, @"默认选择的日期不能小于最小日期！");
        NSAssert(!selectMoreThanMax, @"默认选择的日期不能大于最大日期！");
        if (selectLessThanMin) {
            self.selectDate = self.minLimitDate;
        }
        if (selectMoreThanMax) {
            self.selectDate = self.maxLimitDate;
        }
        
#ifdef DEBUG
        NSLog(@"最小时间date：%@", self.minLimitDate);
        NSLog(@"默认时间date：%@", self.selectDate);
        NSLog(@"最大时间date：%@", self.maxLimitDate);
        
        NSLog(@"最小时间：%@", [NSDate pv_getDateString:self.minLimitDate format:self.selectDateFormatter]);
        NSLog(@"默认时间：%@", [NSDate pv_getDateString:self.selectDate format:self.selectDateFormatter]);
        NSLog(@"最大时间：%@", [NSDate pv_getDateString:self.maxLimitDate format:self.selectDateFormatter]);
#endif
        
        if (self.style == PVDatePickerStyleCustom) {
            [self initDefaultDateArray];
        }
        [self initUI];
        
        // 默认滚动的行
        if (self.style == PVDatePickerStyleSystem) {
            [self.datePicker setDate:self.selectDate animated:NO];
        } else if (self.style == PVDatePickerStyleCustom) {
            [self scrollToSelectDate:self.selectDate animated:NO];
        }
    }
    return self;
}

- (void)setupSelectDateFormatter:(PVDatePickerMode)model {
    switch (model) {
        case PVDatePickerModeTime:
        {
            self.selectDateFormatter = @"HH:mm";
            self.style = PVDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeTime;
        }
            break;
        case PVDatePickerModeDate:
        {
            self.selectDateFormatter = @"yyyy-MM-dd";
            self.style = PVDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeDate;
        }
            break;
        case PVDatePickerModeDateAndTime:
        {
            self.selectDateFormatter = @"yyyy-MM-dd HH:mm";
            self.style = PVDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeDateAndTime;
        }
            break;
        case PVDatePickerModeCountDownTimer:
        {
            self.selectDateFormatter = @"HH:mm";
            self.style = PVDatePickerStyleSystem;
            _datePickerMode = UIDatePickerModeCountDownTimer;
        }
            break;
            
        case PVDatePickerModeYMDHM:
        {
            self.selectDateFormatter = @"yyyy-MM-dd HH:mm";
            self.style = PVDatePickerStyleCustom;
        }
            break;
            
        case PVDatePickerModeYMDHMS:
        {
            self.selectDateFormatter = @"yyyy-MM-dd HH:mm:ss";
            self.style = PVDatePickerStyleCustom;
        }
            break;
        case PVDatePickerModeMDHM:
        {
            self.selectDateFormatter = @"MM-dd HH:mm";
            self.style = PVDatePickerStyleCustom;
        }
            break;
        case PVDatePickerModeYMD:
        {
            self.selectDateFormatter = @"yyyy-MM-dd";
            self.style = PVDatePickerStyleCustom;
        }
            break;
        case PVDatePickerModeYM:
        {
            self.selectDateFormatter = @"yyyy-MM";
            self.style = PVDatePickerStyleCustom;
        }
            break;
        case PVDatePickerModeY:
        {
            self.selectDateFormatter = @"yyyy";
            self.style = PVDatePickerStyleCustom;
        }
            break;
        case PVDatePickerModeMD:
        {
            self.selectDateFormatter = @"MM-dd";
            self.style = PVDatePickerStyleCustom;
        }
            break;
        case PVDatePickerModeHM:
        {
            self.selectDateFormatter = @"HH:mm";
            self.style = PVDatePickerStyleCustom;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = _title;
    // 添加时间选择器
    if (self.style == PVDatePickerStyleSystem) {
        [self.alertView addSubview:self.datePicker];
    } else if (self.style == PVDatePickerStyleCustom) {
        [self.alertView addSubview:self.pickerView];
    }
    if (_themeColor && [_themeColor isKindOfClass:[UIColor class]]) {
        [self setupThemeColor:_themeColor];
    }
}

#pragma mark - 设置日期数据源数组
- (void)initDefaultDateArray {
    // 1. 设置 yearArr 数组
    [self setupYearArr];
    // 2.设置 monthArr 数组
    [self setupMonthArr:self.selectDate.pv_year];
    // 3.设置 dayArr 数组
    [self setupDayArr:self.selectDate.pv_year month:self.selectDate.pv_month];
    // 4.设置 hourArr 数组
    [self setupHourArr:self.selectDate.pv_year month:self.selectDate.pv_month day:self.selectDate.pv_day];
    // 5.设置 minuteArr 数组
    [self setupMinuteArr:self.selectDate.pv_year month:self.selectDate.pv_month day:self.selectDate.pv_day hour:self.selectDate.pv_hour];
    // 6.
    [self setupSecondArr:self.selectDate.pv_year month:self.selectDate.pv_month day:self.selectDate.pv_day hour:self.selectDate.pv_hour minute:self.selectDate.pv_minute];
    // 根据 默认选择的日期 计算出 对应的索引
    _yearIndex = self.selectDate.pv_year - self.minLimitDate.pv_year;
    _monthIndex = self.selectDate.pv_month - ((_yearIndex == 0) ? self.minLimitDate.pv_month : 1);
    _dayIndex = self.selectDate.pv_day - ((_yearIndex == 0 && _monthIndex == 0) ? self.minLimitDate.pv_day : 1);
    _hourIndex = self.selectDate.pv_hour - ((_yearIndex == 0 && _monthIndex == 0 && _dayIndex == 0) ? self.minLimitDate.pv_hour : 0);
    _minuteIndex = self.selectDate.pv_minute - ((_yearIndex == 0 && _monthIndex == 0 && _dayIndex == 0 && _hourIndex == 0) ? self.minLimitDate.pv_minute : 0);
    _secondIndex = self.selectDate.pv_second - ((_yearIndex == 0 && _monthIndex == 0 && _dayIndex == 0 && _hourIndex == 0 && _minuteIndex == 0) ? self.minLimitDate.pv_second : 0);
}

#pragma mark - 更新日期数据源数组
- (void)updateDateArray {
    NSInteger year = [self.yearArr[_yearIndex] integerValue];
    // 1.设置 monthArr 数组
    [self setupMonthArr:year];
    // 更新索引：防止更新 monthArr 后数组越界
    _monthIndex = (_monthIndex > self.monthArr.count - 1) ? (self.monthArr.count - 1) : _monthIndex;
    
    NSInteger month = [self.monthArr[_monthIndex] integerValue];
    // 2.设置 dayArr 数组
    [self setupDayArr:year month:month];
    // 更新索引：防止更新 dayArr 后数组越界
    _dayIndex = (_dayIndex > self.dayArr.count - 1) ? (self.dayArr.count - 1) : _dayIndex;
    
    NSInteger day = [self.dayArr[_dayIndex] integerValue];
    // 3.设置 hourArr 数组
    [self setupHourArr:year month:month day:day];
    // 更新索引：防止更新 hourArr 后数组越界
    _hourIndex = (_hourIndex > self.hourArr.count - 1) ? (self.hourArr.count - 1) : _hourIndex;
    
    NSInteger hour = [self.hourArr[_hourIndex] integerValue];
    // 4.设置 minuteArr 数组
    [self setupMinuteArr:year month:month day:day hour:hour];
    // 更新索引：防止更新 monthArr 后数组越界
    _minuteIndex = (_minuteIndex > self.minuteArr.count - 1) ? (self.minuteArr.count - 1) : _minuteIndex;
    
    NSInteger minute = [self.minuteArr[_minuteIndex] integerValue];
    // 4.设置 secondArr 数组
    [self setupSecondArr:year month:month day:day hour:hour minute:minute];
    // 更新索引：防止更新 monthArr 后数组越界
    _secondIndex = (_secondIndex > self.secondArr.count - 1) ? (self.secondArr.count - 1) : _secondIndex;
}

// 设置 yearArr 数组
- (void)setupYearArr {
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = self.minLimitDate.pv_year; i <= self.maxLimitDate.pv_year; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.yearArr = [tempArr copy];
}

// 设置 monthArr 数组
- (void)setupMonthArr:(NSInteger)year {
    NSInteger startMonth = 1;
    NSInteger endMonth = 12;
    if (year == self.minLimitDate.pv_year) {
        startMonth = self.minLimitDate.pv_month;
    }
    if (year == self.maxLimitDate.pv_year) {
        endMonth = self.maxLimitDate.pv_month;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endMonth - startMonth + 1)];
    for (NSInteger i = startMonth; i <= endMonth; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.monthArr = [tempArr copy];
}

// 设置 dayArr 数组
- (void)setupDayArr:(NSInteger)year month:(NSInteger)month {
    NSInteger startDay = 1;
    NSInteger endDay = [NSDate pv_getDaysInYear:year month:month];
    if (year == self.minLimitDate.pv_year && month == self.minLimitDate.pv_month) {
        startDay = self.minLimitDate.pv_day;
    }
    if (year == self.maxLimitDate.pv_year && month == self.maxLimitDate.pv_month) {
        endDay = self.maxLimitDate.pv_day;
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i = startDay; i <= endDay; i++) {
        [tempArr addObject:[NSString stringWithFormat:@"%zi",i]];
    }
    self.dayArr = [tempArr copy];
}

// 设置 hourArr 数组
- (void)setupHourArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSInteger startHour = 0;
    NSInteger endHour = 23;
    if (year == self.minLimitDate.pv_year && month == self.minLimitDate.pv_month && day == self.minLimitDate.pv_day) {
        startHour = self.minLimitDate.pv_hour;
    }
    if (year == self.maxLimitDate.pv_year && month == self.maxLimitDate.pv_month && day == self.maxLimitDate.pv_day) {
        endHour = self.maxLimitDate.pv_hour;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endHour - startHour + 1)];
    for (NSInteger i = startHour; i <= endHour; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.hourArr = [tempArr copy];
}

// 设置 minuteArr 数组
- (void)setupMinuteArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
    NSInteger startMinute = 0;
    NSInteger endMinute = 59;
    if (year == self.minLimitDate.pv_year && month == self.minLimitDate.pv_month && day == self.minLimitDate.pv_day && hour == self.minLimitDate.pv_hour) {
        startMinute = self.minLimitDate.pv_minute;
    }
    if (year == self.maxLimitDate.pv_year && month == self.maxLimitDate.pv_month && day == self.maxLimitDate.pv_day && hour == self.maxLimitDate.pv_hour) {
        endMinute = self.maxLimitDate.pv_minute;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endMinute - startMinute + 1)];
    for (NSInteger i = startMinute; i <= endMinute; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.minuteArr = [tempArr copy];
}

// 设置 secondArr 数组
- (void)setupSecondArr:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    NSInteger startSecond = 0;
    NSInteger endSecond = 59;
    if (year == self.minLimitDate.pv_year && month == self.minLimitDate.pv_month && day == self.minLimitDate.pv_day && hour == self.minLimitDate.pv_hour && minute == self.minLimitDate.pv_minute) {
        startSecond = self.minLimitDate.pv_second;
    }
    if (year == self.maxLimitDate.pv_year && month == self.maxLimitDate.pv_month && day == self.maxLimitDate.pv_day && hour == self.maxLimitDate.pv_hour && minute == self.minLimitDate.pv_minute) {
        endSecond = self.maxLimitDate.pv_second;
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(endSecond - startSecond + 1)];
    for (NSInteger i = startSecond; i <= endSecond; i++) {
        [tempArr addObject:[@(i) stringValue]];
    }
    self.secondArr = [tempArr copy];
}

#pragma mark - 滚动到指定的时间位置
- (void)scrollToSelectDate:(NSDate *)selectDate animated:(BOOL)animated {
    // 根据 当前选择的日期 计算出 对应的索引
    NSInteger yearIndex = selectDate.pv_year - self.minLimitDate.pv_year;
    NSInteger monthIndex = selectDate.pv_month - ((yearIndex == 0) ? self.minLimitDate.pv_month : 1);
    NSInteger dayIndex = selectDate.pv_day - ((yearIndex == 0 && monthIndex == 0) ? self.minLimitDate.pv_day : 1);
    NSInteger hourIndex = selectDate.pv_hour - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0) ? self.minLimitDate.pv_hour : 0);
    NSInteger minuteIndex = selectDate.pv_minute - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0 && hourIndex == 0) ? self.minLimitDate.pv_minute : 0);
    NSInteger secondIndex = selectDate.pv_second - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0 && hourIndex == 0 && minuteIndex == 0) ? self.minLimitDate.pv_second : 0);
    
    NSArray *indexArr = [NSArray array];
    if (self.showType == PVDatePickerModeYMDHMS) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex),@(secondIndex)];
    } else if (self.showType == PVDatePickerModeYMDHM) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex)];
    } else if (self.showType == PVDatePickerModeMDHM) {
        indexArr = @[@(monthIndex), @(dayIndex), @(hourIndex), @(minuteIndex)];
    } else if (self.showType == PVDatePickerModeYMD) {
        indexArr = @[@(yearIndex), @(monthIndex), @(dayIndex)];
    } else if (self.showType == PVDatePickerModeYM) {
        indexArr = @[@(yearIndex), @(monthIndex)];
    } else if (self.showType == PVDatePickerModeY) {
        indexArr = @[@(yearIndex)];
    } else if (self.showType == PVDatePickerModeMD) {
        indexArr = @[@(monthIndex), @(dayIndex)];
    } else if (self.showType == PVDatePickerModeHM) {
        indexArr = @[@(hourIndex), @(minuteIndex)];
    }
    for (NSInteger i = 0; i < indexArr.count; i++) {
        [self.pickerView selectRow:[indexArr[i] integerValue] inComponent:i animated:animated];
    }
}

#pragma mark - 时间选择器1
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, self.alertView.frame.size.width, kPickerHeight)];

        _datePicker.centerY = self.alertView.height/2;
        _datePicker.backgroundColor = [UIColor whiteColor];
        // 设置子视图的大小随着父视图变化
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _datePicker.datePickerMode = _datePickerMode;
        // 设置该UIDatePicker的国际化Locale，以简体中文习惯显示日期，UIDatePicker控件默认使用iOS系统的国际化Locale
        _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CHS_CN"];
        // textColor 隐藏属性，使用KVC赋值
        // [_datePicker setValue:[UIColor blackColor] forKey:@"textColor"];
        // 设置时间范围
        if (self.minLimitDate) {
            _datePicker.minimumDate = self.minLimitDate;
        }
        if (self.maxLimitDate) {
            _datePicker.maximumDate = self.maxLimitDate;
        }
        // 滚动改变值的响应事件
        [_datePicker addTarget:self action:@selector(didSelectValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - 时间选择器2
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, self.alertView.frame.size.width, kPickerHeight)];
        _pickerView.centerY = self.alertView.height/2;
        _pickerView.backgroundColor = [UIColor whiteColor];
        
        // 设置子视图的大小随着父视图变化
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource
// 1.指定pickerview有几个表盘(几列)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.showType == PVDatePickerModeYMDHMS) {
        return 6;
    }else if (self.showType == PVDatePickerModeYMDHM) {
        return 5;
    } else if (self.showType == PVDatePickerModeMDHM) {
        return 4;
    } else if (self.showType == PVDatePickerModeYMD) {
        return 3;
    } else if (self.showType == PVDatePickerModeYM) {
        return 2;
    } else if (self.showType == PVDatePickerModeY) {
        return 1;
    } else if (self.showType == PVDatePickerModeMD) {
        return 2;
    } else if (self.showType == PVDatePickerModeHM) {
        return 2;
    }
    return 0;
}

// 2.指定每个表盘上有几行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *rowsArr = [NSArray array];
    
    if (self.showType == PVDatePickerModeYMDHMS) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count),@(self.secondArr.count)];
    } else if (self.showType == PVDatePickerModeYMDHM) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count)];
    } else if (self.showType == PVDatePickerModeMDHM) {
        rowsArr = @[@(self.monthArr.count), @(self.dayArr.count), @(self.hourArr.count), @(self.minuteArr.count)];
    } else if (self.showType == PVDatePickerModeYMD) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count), @(self.dayArr.count)];
    } else if (self.showType == PVDatePickerModeYM) {
        rowsArr = @[@(self.yearArr.count), @(self.monthArr.count)];
    } else if (self.showType == PVDatePickerModeY) {
        rowsArr = @[@(self.yearArr.count)];
    } else if (self.showType == PVDatePickerModeMD) {
        rowsArr = @[@(self.monthArr.count), @(self.dayArr.count)];
    } else if (self.showType == PVDatePickerModeHM) {
        rowsArr = @[@(self.hourArr.count), @(self.minuteArr.count)];
    }
    return [rowsArr[component] integerValue];
}

#pragma mark - UIPickerViewDelegate
// 3.设置 pickerView 的 显示内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    // 设置分割线的颜色
//    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0f];
//    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0f];
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20.0f * kScaleFit];
        // 字体自适应属性
        label.adjustsFontSizeToFitWidth = YES;
        // 自适应最小字体缩放比例
        label.minimumScaleFactor = 0.5f;
    }
    // 给选择器上的label赋值
    [self setDateLabelText:label component:component row:row];
    return label;
}

// 4.选中时回调的委托方法，在此方法中实现省份和城市间的联动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 获取滚动后选择的日期
    self.selectDate = [self getDidSelectedDate:component row:row];
    // 设置是否开启自动回调
    if (_isAutoSelect) {
        // 滚动完成后，执行block回调
        if (self.resultBlock) {
            NSString *selectDateValue = [NSDate pv_getDateString:self.selectDate format:self.selectDateFormatter];
            self.resultBlock(selectDateValue);
        }
    }
}

// 设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.0f * kScaleFit;
}

- (void)setDateLabelText:(UILabel *)label component:(NSInteger)component row:(NSInteger)row {
//    if (self.showType == PVDatePickerModeYMDHM) {
//        if (component == 0) {
//            label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
//        } else if (component == 1) {
//            label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
//        } else if (component == 2) {
//            label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
//        } else if (component == 3) {
//            label.text = [NSString stringWithFormat:@"%@时", self.hourArr[row]];
//        } else if (component == 4) {
//            label.text = [NSString stringWithFormat:@"%@分", self.minuteArr[row]];
//        }
//    } else if (self.showType == PVDatePickerModeMDHM) {
//        if (component == 0) {
//            label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
//        } else if (component == 1) {
//            label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
//        } else if (component == 2) {
//            label.text = [NSString stringWithFormat:@"%@时", self.hourArr[row]];
//        } else if (component == 3) {
//            label.text = [NSString stringWithFormat:@"%@分", self.minuteArr[row]];
//        }
//    } else if (self.showType == PVDatePickerModeYMD) {
//        if (component == 0) {
//            label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
//        } else if (component == 1) {
//            label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
//        } else if (component == 2) {
//            label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
//        }
//    } else if (self.showType == PVDatePickerModeYM) {
//        if (component == 0) {
//            label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
//        } else if (component == 1) {
//            label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
//        }
//    } else if (self.showType == PVDatePickerModeY) {
//        if (component == 0) {
//            label.text = [NSString stringWithFormat:@"%@年", self.yearArr[row]];
//        }
//    } else if (self.showType == PVDatePickerModeMD) {
//        if (component == 0) {
//            label.text = [NSString stringWithFormat:@"%@月", self.monthArr[row]];
//        } else if (component == 1) {
//            label.text = [NSString stringWithFormat:@"%@日", self.dayArr[row]];
//        }
//    } else if (self.showType == PVDatePickerModeHM) {
//        if (component == 0) {
//            label.text = [NSString stringWithFormat:@"%@时", self.hourArr[row]];
//        } else if (component == 1) {
//            label.text = [NSString stringWithFormat:@"%@分", self.minuteArr[row]];
//        }
//    }
    
    if (self.showType == PVDatePickerModeYMDHMS) {
          if (component == 0) {
              label.text = [NSString stringWithFormat:@"%@", self.yearArr[row]];
          } else if (component == 1) {
              label.text = [NSString stringWithFormat:@"%@", self.monthArr[row]];
          } else if (component == 2) {
              label.text = [NSString stringWithFormat:@"%@", self.dayArr[row]];
          } else if (component == 3) {
              label.text = [NSString stringWithFormat:@"%@", self.hourArr[row]];
          } else if (component == 4) {
              label.text = [NSString stringWithFormat:@"%@", self.minuteArr[row]];
          }else if (component == 5) {
              label.text = [NSString stringWithFormat:@"%@", self.secondArr[row]];
          }
      }else if (self.showType == PVDatePickerModeYMDHM) {
          if (component == 0) {
              label.text = [NSString stringWithFormat:@"%@", self.yearArr[row]];
          } else if (component == 1) {
              label.text = [NSString stringWithFormat:@"%@", self.monthArr[row]];
          } else if (component == 2) {
              label.text = [NSString stringWithFormat:@"%@", self.dayArr[row]];
          } else if (component == 3) {
              label.text = [NSString stringWithFormat:@"%@", self.hourArr[row]];
          } else if (component == 4) {
              label.text = [NSString stringWithFormat:@"%@", self.minuteArr[row]];
          }
      } else if (self.showType == PVDatePickerModeMDHM) {
          if (component == 0) {
              label.text = [NSString stringWithFormat:@"%@", self.monthArr[row]];
          } else if (component == 1) {
              label.text = [NSString stringWithFormat:@"%@", self.dayArr[row]];
          } else if (component == 2) {
              label.text = [NSString stringWithFormat:@"%@", self.hourArr[row]];
          } else if (component == 3) {
              label.text = [NSString stringWithFormat:@"%@", self.minuteArr[row]];
          }
      } else if (self.showType == PVDatePickerModeYMD) {
          if (component == 0) {
              label.text = [NSString stringWithFormat:@"%@", self.yearArr[row]];
          } else if (component == 1) {
              label.text = [NSString stringWithFormat:@"%@", self.monthArr[row]];
          } else if (component == 2) {
              label.text = [NSString stringWithFormat:@"%@", self.dayArr[row]];
          }
      } else if (self.showType == PVDatePickerModeYM) {
          if (component == 0) {
              label.text = [NSString stringWithFormat:@"%@", self.yearArr[row]];
          } else if (component == 1) {
              label.text = [NSString stringWithFormat:@"%@", self.monthArr[row]];
          }
      } else if (self.showType == PVDatePickerModeY) {
          if (component == 0) {
              label.text = [NSString stringWithFormat:@"%@", self.yearArr[row]];
          }
      } else if (self.showType == PVDatePickerModeMD) {
          if (component == 0) {
              label.text = [NSString stringWithFormat:@"%@", self.monthArr[row]];
          } else if (component == 1) {
              label.text = [NSString stringWithFormat:@"%@", self.dayArr[row]];
          }
      } else if (self.showType == PVDatePickerModeHM) {
          if (component == 0) {
              label.text = [NSString stringWithFormat:@"%@", self.hourArr[row]];
          } else if (component == 1) {
              label.text = [NSString stringWithFormat:@"%@", self.minuteArr[row]];
          }
      }
}

- (NSDate *)getDidSelectedDate:(NSInteger)component row:(NSInteger)row {
    NSString *selectDateValue = nil;
    
    if (self.showType == PVDatePickerModeYMDHMS) {
        if (component == 0) {
            _yearIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
            [self.pickerView reloadComponent:5];
        } else if (component == 1) {
            _monthIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
            [self.pickerView reloadComponent:5];
        } else if (component == 2) {
            _dayIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
            [self.pickerView reloadComponent:5];
        } else if (component == 3) {
            _hourIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:4];
            [self.pickerView reloadComponent:5];
        } else if (component == 4) {
            _minuteIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:5];
        } else if (component == 5) {
            _secondIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%@-%02ld-%02ld %02ld:%02ld:%02ld", self.yearArr[_yearIndex], [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue], [self.hourArr[_hourIndex] integerValue], [self.minuteArr[_minuteIndex] integerValue],[self.secondArr[_secondIndex] integerValue]];
        
    }else if (self.showType == PVDatePickerModeYMDHM) {
        if (component == 0) {
            _yearIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        } else if (component == 1) {
            _monthIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        } else if (component == 2) {
            _dayIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:3];
            [self.pickerView reloadComponent:4];
        } else if (component == 3) {
            _hourIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:4];
        } else if (component == 4) {
            _minuteIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%@-%02ld-%02ld %02ld:%02ld", self.yearArr[_yearIndex], [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue], [self.hourArr[_hourIndex] integerValue], [self.minuteArr[_minuteIndex] integerValue]];
    } else if (self.showType == PVDatePickerModeMDHM) {
        if (component == 0) {
            _monthIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
        } else if (component == 1) {
            _dayIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:2];
            [self.pickerView reloadComponent:3];
        } else if (component == 2) {
            _hourIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:3];
        } else if (component == 3) {
            _minuteIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld", [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue], [self.hourArr[_hourIndex] integerValue], [self.minuteArr[_minuteIndex] integerValue]];
    } else if (self.showType == PVDatePickerModeYMD) {
        if (component == 0) {
            _yearIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
        } else if (component == 1) {
            _monthIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:2];
        } else if (component == 2) {
            _dayIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%@-%02ld-%02ld", self.yearArr[_yearIndex], [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue]];
    } else if (self.showType == PVDatePickerModeYM) {
        if (component == 0) {
            _yearIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            _monthIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%@-%02ld", self.yearArr[_yearIndex], [self.monthArr[_monthIndex] integerValue]];
    } else if (self.showType == PVDatePickerModeY) {
        if (component == 0) {
            _yearIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%@", self.yearArr[_yearIndex]];
    } else if (self.showType == PVDatePickerModeMD) {
        if (component == 0) {
            _monthIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            _dayIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%02ld-%02ld", [self.monthArr[_monthIndex] integerValue], [self.dayArr[_dayIndex] integerValue]];
    } else if (self.showType == PVDatePickerModeHM) {
        if (component == 0) {
            _hourIndex = row;
            [self updateDateArray];
            [self.pickerView reloadComponent:1];
        } else if (component == 1) {
            _minuteIndex = row;
        }
        selectDateValue = [NSString stringWithFormat:@"%02ld:%02ld", [self.hourArr[_hourIndex] integerValue], [self.minuteArr[_minuteIndex] integerValue]];
    }
    return [NSDate pv_getDate:selectDateValue format:self.selectDateFormatter];
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 时间选择器的滚动响应事件
- (void)didSelectValueChanged:(UIDatePicker *)sender {
    // 读取日期：datePicker.date
    self.selectDate = sender.date;
    
    BOOL selectLessThanMin = [self.selectDate pv_compare:self.minLimitDate format:self.selectDateFormatter] == NSOrderedAscending;
    BOOL selectMoreThanMax = [self.selectDate pv_compare:self.maxLimitDate format:self.selectDateFormatter] == NSOrderedDescending;
    if (selectLessThanMin) {
        self.selectDate = self.minLimitDate;
    }
    if (selectMoreThanMax) {
        self.selectDate = self.maxLimitDate;
    }
    [self.datePicker setDate:self.selectDate animated:YES];
    
    // 设置是否开启自动回调
    if (_isAutoSelect) {
        // 滚动完成后，执行block回调
        if (self.resultBlock) {
            NSString *selectDateValue = [NSDate pv_getDateString:self.selectDate format:self.selectDateFormatter];
            self.resultBlock(selectDateValue);
        }
    }
}

#pragma mark - 取消按钮的点击事件
- (void)clickTopLeftBtn {
    [self dismissWithAnimation:YES];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - 确定按钮的点击事件
- (void)clickTopRightBtn {
    // 点击确定按钮后，执行block回调
    [self dismissWithAnimation:YES];
    if (self.resultBlock) {
        NSString *selectDateValue = [NSDate pv_getDateString:self.selectDate format:self.selectDateFormatter];
        self.resultBlock(selectDateValue);
    }
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
//        CGRect rect = self.alertView.frame;
//        rect.origin.y = SCREEN_HEIGHT;
//        self.alertView.frame = rect;
        self.backgroundView.alpha = 0;
        self.alertView.transform = CGAffineTransformMakeScale(0.25, 0.25);
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 1;
            self.alertView.transform = CGAffineTransformMakeScale(1, 1);
//            CGRect rect = self.alertView.frame;
//            rect.origin.y -= kPickerHeight + kTopViewHeight + pv_BOTTOM_MARGIN;
//            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(0.25, 0.25);
        self.backgroundView.alpha = 0;
//        CGRect rect = self.alertView.frame;
//        rect.origin.y += kPickerHeight + kTopViewHeight + pv_BOTTOM_MARGIN;
//        self.alertView.frame = rect;
//        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - getter 方法
- (NSArray *)yearArr {
    if (!_yearArr) {
        _yearArr = [NSArray array];
    }
    return _yearArr;
}

- (NSArray *)monthArr {
    if (!_monthArr) {
        _monthArr = [NSArray array];
    }
    return _monthArr;
}

- (NSArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSArray array];
    }
    return _dayArr;
}

- (NSArray *)hourArr {
    if (!_hourArr) {
        _hourArr = [NSArray array];
    }
    return _hourArr;
}

- (NSArray *)minuteArr {
    if (!_minuteArr) {
        _minuteArr = [NSArray array];
    }
    return _minuteArr;
}

- (NSArray *)secondArr {
    if (_secondArr == nil) {
        _secondArr = [[NSArray alloc] init];
    }
    return _secondArr;
}


@end
