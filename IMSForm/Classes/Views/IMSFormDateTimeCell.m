//
//  IMSFormDateTimeCell.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/8.
//

#import "IMSFormDateTimeCell.h"
#import "DatePickerView.h"

@interface IMSFormDateTimeCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation IMSFormDateTimeCell

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
    [self.bodyView addSubview:self.textField];
    
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
    self.bodyView.backgroundColor = [UIColor whiteColor];
    
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

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bodyView);
    }];

    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.bodyView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
    }];
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
}

#pragma mark - Private Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    PVDatePickerMode mode = PVDatePickerModeYMD;
    if (self.model.cpnConfig.datePickerMode == UIDatePickerModeTime) {
        mode = PVDatePickerModeHM;
    }else if (self.model.cpnConfig.datePickerMode == UIDatePickerModeDate) {
        mode = PVDatePickerModeYMD;
    }else if (self.model.cpnConfig.datePickerMode == UIDatePickerModeDateAndTime) {
        mode = PVDatePickerModeYMDHMS;
    }

    NSString *defaultString = self.model.value;
    if (!self.model.value || self.model.value.length == 0) {
        defaultString = [NSDate pv_getDateString:[NSDate date] format:self.model.cpnConfig.dateFormat];
    }

    @weakify(self)
    [DatePickerView showDatePickerWithTitle:@"Select" dateType:mode defaultSelValue:defaultString minDate:self.model.cpnConfig.minDate maxDate:self.model.cpnConfig.maxDate isAutoSelect:NO themeColor:nil resultBlock:^(NSString * _Nonnull selectValue) {
        @strongify(self)
        self.textField.text = self.model.value = self.model.param = selectValue;
    }];
    return NO;
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self setTitle:model.title required:model.isRequired];
    
    self.infoLabel.text = model.info;
    
    self.bodyView.userInteractionEnabled = model.isEditable;
    
    self.textField.placeholder = model.placeholder;
    self.textField.text = model.value;
    
    if (model.cpnConfig.datePickerMode == UIDatePickerModeDate) {
        [self.iconButton setImage:[UIImage bundleImageWithNamed:@"ic_date"] forState:UIControlStateNormal];
    }else {
        [self.iconButton setImage:[UIImage bundleImageWithNamed:@"ic_time"] forState:UIControlStateNormal];
    }
    
}


#pragma mark - lazy load
- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.delegate = self;
//        [_textField rounded:4 width:.5 color: HEXCOLOR(0xD6DCDF)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.returnKeyType = UIReturnKeyDone;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        leftView.backgroundColor = [UIColor whiteColor];
        self.iconButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.iconButton setImage:[UIImage bundleImageWithNamed:@"ic_date"] forState:UIControlStateNormal];
        self.iconButton.userInteractionEnabled = NO;
        [leftView addSubview:self.iconButton];
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

@end
