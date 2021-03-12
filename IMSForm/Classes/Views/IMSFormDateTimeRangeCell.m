//
//  IMSFormDateTimeRangeCell.m
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import "IMSFormDateTimeRangeCell.h"
#import <IMSForm/DatePickerView.h>
#import <IMSForm/NSDate+Extension.h>

@interface IMSFormDateTimeRangeCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UITextField *startTextField;
@property (nonatomic, strong) UITextField *endTextField;
@property (strong, nonatomic) UILabel *sepLabel; /**< <#property#> */

@end

@implementation IMSFormDateTimeRangeCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildView];
    }
    return self;
}

#pragma mark - UI

- (void)buildView
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconButton];
    [self.bodyView addSubview:self.startTextField];
    [self.bodyView addSubview:self.endTextField];
    [self.bodyView addSubview:self.sepLabel];

    [self updateUI];
}

- (void)updateUI
{
    self.contentView.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.backgroundHexColor]);

    self.titleLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.titleHexColor]);

    self.titleLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.titleFontSize weight:UIFontWeightMedium];

    self.infoLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.infoFontSize weight:UIFontWeightRegular];
    self.infoLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.infoHexColor]);

    CGFloat spacing = self.model.cpnStyle.spacing;
    self.startTextField.userInteractionEnabled = self.bodyView.userInteractionEnabled = self.model.isEditable;
    self.iconButton.backgroundColor = self.startTextField.backgroundColor = self.bodyView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.top);
        make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
        make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
    }];

    [self.bodyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(spacing);
        make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
        make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
        make.height.mas_equalTo(kIMSFormDefaultHeight);
    }];
    
    [self.iconButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.bodyView).offset(0);
        make.size.mas_equalTo(CGSizeMake(kIMSFormDefaultHeight, kIMSFormDefaultHeight));
    }];
    
    [self.sepLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bodyView);
        make.centerX.mas_equalTo(self.bodyView).offset(kIMSFormDefaultHeight/2);
        make.size.mas_equalTo(CGSizeMake(kIMSFormDefaultHeight, kIMSFormDefaultHeight));
    }];

    [self.startTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.bodyView).offset(0);
        make.left.mas_equalTo(self.iconButton.mas_right).offset(0);
        make.right.mas_equalTo(self.sepLabel.mas_left).offset(0);
    }];
    
    [self.endTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.bodyView).offset(0);
        make.right.mas_equalTo(self.bodyView).offset(-kIMSFormDefaultHeight/4);
        make.left.mas_equalTo(self.sepLabel.mas_right).offset(0);
    }];

    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.bodyView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    IMSFormDateTimeRangeModel *dateTimeModel = (IMSFormDateTimeRangeModel *)self.model;
    
    // date format
    PVDatePickerMode mode = PVDatePickerModeYMD;
    NSString *dateFormatStr = @"";
    if ([dateTimeModel.cpnConfig.datePickerType isEqualToString:IMSFormDateTimeType_Time]) {
        mode = PVDatePickerModeHM;
        dateFormatStr = @"HH:mm";
    } else if ([dateTimeModel.cpnConfig.datePickerType isEqualToString:IMSFormDateTimeType_Date]) {
        mode = PVDatePickerModeYMD;
        dateFormatStr = @"yyyy-MM-dd";
    } else if ([dateTimeModel.cpnConfig.datePickerType isEqualToString:IMSFormDateTimeType_DateTime]) {
        mode = PVDatePickerModeYMDHMS;
        dateFormatStr = @"yyyy-MM-dd HH:mm:ss";
    }
    
    // 最小日期不能大于最大日期
    NSDate *minDate =  [[NSDate date] pv_getNewDateAddDays:dateTimeModel.cpnConfig.minDate];
    NSDate *maxDate = [[NSDate date] pv_getNewDateAddDays:dateTimeModel.cpnConfig.maxDate];
    if ([textField isEqual:self.startTextField]) {
        if (self.endTextField.text.length > 0) {
            NSString *dateStr = self.endTextField.text;
            NSDate *endDate = [NSDate dateFromString:dateStr format:dateFormatStr];
            NSComparisonResult result = [endDate compare:maxDate];
            maxDate = (result == NSOrderedAscending) ? endDate : maxDate;
        }
    }
    if ([textField isEqual:self.endTextField]) {
        if (self.startTextField.text.length > 0) {
            NSString *dateStr = self.startTextField.text;
            NSDate *startDate = [NSDate dateFromString:dateStr format:dateFormatStr];
            NSComparisonResult result = [startDate compare:minDate];
            minDate = (result == NSOrderedAscending) ? minDate : startDate;
        }
    }

    // default date of datePicker
    // 设置默认显示的日期为今天
    // 默认选择的日期不能小于最小日期
    // 默认选择的日期不能大于最大日期
    NSString *defaultString = textField.text;
    if (textField.text.length == 0) {
        NSDate *nowDate = [NSDate date];
        NSDate *compareDate = minDate;
        // [A compare:B] : NSOrderedAscending A < B; NSOrderedDescending A > B; NSOrderedSame A == B
        NSComparisonResult result = [nowDate compare:minDate]; // 与日历设置的最小日期对比，找出最大值
        compareDate = (result == NSOrderedAscending) ? minDate : nowDate;
        result = [compareDate compare:maxDate]; // 与日历设置的最大日期对比，找出最小值
        NSDate *defaultDate = (result == NSOrderedAscending) ? compareDate : maxDate;
        defaultString = [NSDate pv_getDateString:defaultDate format:dateFormatStr];
    }

    @weakify(self)
    [DatePickerView showDatePickerWithTitle: @"Select" dateType: mode defaultSelValue: defaultString minDate: minDate maxDate: maxDate isAutoSelect: NO themeColor: nil resultBlock:^(NSString *_Nonnull selectValue) {
        @strongify(self)
        if (textField == self.startTextField) {
            self.startTextField.text = selectValue;
        } else {
            self.endTextField.text = selectValue;
        }
        // 转换时间戳
        NSString *startDateStr = self.startTextField.text;
        NSString *endDateStr = self.endTextField.text.length ? self.endTextField.text : startDateStr;
        self.model.value = [NSString stringWithFormat:@"%f;%f", [[NSDate pv_getDate:startDateStr format:dateFormatStr] timeIntervalSince1970], [[NSDate pv_getDate:endDateStr format:dateFormatStr] timeIntervalSince1970]];
        NSLog(@"%@", self.model.value);
        // call back
        if (self.didUpdateFormModelBlock) {
            self.didUpdateFormModelBlock(self, self.model, nil);
        }
    }];
    return NO;
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormDateTimeRangeModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];

    [self updateUI];

    [self setTitle:model.title required:model.isRequired];
    self.infoLabel.text = model.info;
    self.startTextField.placeholder = model.cpnConfig.startPlaceholder ? : @"Please Select";
    self.endTextField.placeholder = model.cpnConfig.endPlaceholder ? : @"Please Select";
    
    // reset minDate & maxDate, 防止 minDate > maxDate
    double min = model.cpnConfig.minDate;
    double max = model.cpnConfig.maxDate;
    self.model.cpnConfig.minDate = MIN(min, max);
    self.model.cpnConfig.maxDate = MAX(min, max);

    IMSFormDateTimeRangeModel *dateTimeModel = (IMSFormDateTimeRangeModel *)model;
    NSString *dateFormat = @"";
    if ([dateTimeModel.cpnConfig.datePickerType isEqualToString:IMSFormDateTimeType_Time]) {
        dateFormat = @"HH:mm";
        [self.iconButton setImage:[UIImage bundleImageWithNamed:@"ic_time"] forState:UIControlStateNormal];
    } else if ([dateTimeModel.cpnConfig.datePickerType isEqualToString:IMSFormDateTimeType_Date]) {
        dateFormat = @"yyyy-MM-dd";
        [self.iconButton setImage:[UIImage bundleImageWithNamed:@"ic_date"] forState:UIControlStateNormal];
    } else if ([dateTimeModel.cpnConfig.datePickerType isEqualToString:IMSFormDateTimeType_DateTime]) {
        dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [self.iconButton setImage:[UIImage bundleImageWithNamed:@"ic_time"] forState:UIControlStateNormal];
    }
    // 时间戳转成对应的值
    // 如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    if (model.value.length) {
        NSArray *timeArray = [model.value componentsSeparatedByString:@";"];
        NSString *startTime = timeArray.firstObject;
        self.startTextField.text = [NSDate pv_getDateStringForTime:startTime.doubleValue format:dateFormat];
        NSString *endTime = timeArray.lastObject;
        self.endTextField.text = [NSDate pv_getDateStringForTime:endTime.doubleValue format:dateFormat];
    } else {
        self.startTextField.text = @"";
        self.endTextField.text = @"";
    }
}

#pragma mark - Getters

- (UITextField *)startTextField {
    if (_startTextField == nil) {
        _startTextField = [[UITextField alloc] init];
        _startTextField.font = [UIFont systemFontOfSize:12];
        _startTextField.delegate = self;
        _startTextField.returnKeyType = UIReturnKeyDone;
        _startTextField.textAlignment = NSTextAlignmentCenter;
//        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        leftView.backgroundColor = [UIColor whiteColor];
//        self.iconButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//        [self.iconButton setImage:[UIImage bundleImageWithNamed:@"ic_date"] forState:UIControlStateNormal];
//        self.iconButton.userInteractionEnabled = NO;
//        [leftView addSubview:self.iconButton];
//        _startTextField.leftView = leftView;
//        _startTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _startTextField;
}

- (UITextField *)endTextField {
    if (_endTextField == nil) {
        _endTextField = [[UITextField alloc] init];
        _endTextField.font = [UIFont systemFontOfSize:12];
        _endTextField.delegate = self;
        _endTextField.returnKeyType = UIReturnKeyDone;
        _endTextField.textAlignment = NSTextAlignmentCenter;
//        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        leftView.backgroundColor = [UIColor whiteColor];
//        self.iconButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//        [self.iconButton setImage:[UIImage bundleImageWithNamed:@"ic_date"] forState:UIControlStateNormal];
//        self.iconButton.userInteractionEnabled = NO;
//        [leftView addSubview:self.iconButton];
//        _endTextField.leftView = leftView;
//        _endTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _endTextField;
}

- (UIButton *)iconButton
{
    if (!_iconButton) {
        _iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_iconButton setImage:[UIImage bundleImageWithNamed:@"ic_date"] forState:UIControlStateNormal];
        _iconButton.userInteractionEnabled = NO;
    }
    return _iconButton;
}

- (UILabel *)sepLabel
{
    if (!_sepLabel) {
        _sepLabel = [[UILabel alloc] init];
        _sepLabel.text = @"-";
        _sepLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sepLabel;
}

@end
