//
//  IMSFormCurrencyCell.m
//  IMSForm
//
//  Created by cjf on 22/1/2021.
//

#import "IMSFormCurrencyCell.h"
#import <IMSForm/IMSFormManager.h>
#import <IMSForm/IMSFormSelectView.h>
#import <IMSForm/IMSPopupSingleSelectListView.h>

@interface IMSFormCurrencyCell () <UITextFieldDelegate>

@property (strong, nonatomic) IMSFormSelectView *suffixView; /**< <#property#> */
@property (nonatomic, strong) IMSPopupSingleSelectListView *suffixSingleSelectListView; /**< <#property#> */

@property (strong, nonatomic) UIView *ctnView; /**< <#property#> */
@property (strong, nonatomic) UILabel *prefixLabel; /**< <#property#> */
@property (strong, nonatomic) UILabel *suffixLabel; /**< <#property#> */

@end

@implementation IMSFormCurrencyCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildView];

        __weak __typeof__(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
            __typeof__(self) strongSelf = weakSelf;
            if (note.object == strongSelf.textField) {
                
                CGFloat value = MAX(strongSelf.model.value.floatValue, strongSelf.model.cpnConfig.min);
                value = MIN(value, strongSelf.model.cpnConfig.max);
                strongSelf.textField.text = [NSString getRoundFloat:value withPrecisionNum:strongSelf.model.cpnConfig.precision];
                strongSelf.textField.placeholder = strongSelf.model.placeholder ? : @"Please enter";
                
                // call back
                if (strongSelf.didUpdateFormModelBlock) {
                    strongSelf.didUpdateFormModelBlock(strongSelf, strongSelf.model, nil);
                }
            }
        }];
    }
    return self;
}

#pragma mark - UI

- (void)buildView
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.bodyView];
    [self.bodyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.bodyView addSubview:self.ctnView];
    [self.ctnView addSubview:self.textField];

    [self updateUI];
}

- (void)updateUI
{
    self.contentView.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.backgroundHexColor]);

    self.titleLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.titleHexColor]);
    self.titleLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.titleFontSize weight:UIFontWeightMedium];

    self.infoLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.infoFontSize weight:UIFontWeightRegular];
    self.infoLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.infoHexColor]);

    self.bodyView.userInteractionEnabled = self.model.isEditable;
    self.bodyView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;

//    if (self.model.isEditable) {
//        self.textField.keyboardType = [self keyboardWithTextType:IMSFormTextType_Money];
//    }

    CGFloat spacing = self.model.cpnStyle.spacing;
    if ([self.model.cpnStyle.layout isEqualToString:IMSFormLayoutType_Horizontal]) {
        [self.bodyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(spacing);
            make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.top + 8);
            make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
            make.right.mas_equalTo(self.bodyView.mas_left).mas_offset(-self.model.cpnStyle.spacing);
            make.width.mas_lessThanOrEqualTo(150);
        }];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.ctnView).with.insets(UIEdgeInsetsMake(0, 10, 0, 10));
            make.height.mas_equalTo(kIMSFormDefaultHeight);
        }];
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];
    } else {
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
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];

        [self buildBodyViewSubViews];
    }
}

- (void)buildBodyViewSubViews
{
    // suffixView
    if (![self.bodyView.subviews containsObject:self.suffixView]) {
        [self.bodyView addSubview:self.suffixView];
    }
    [self.suffixView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.bodyView);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    [self.suffixView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    self.suffixView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);

    [self.ctnView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.bodyView);
        make.left.mas_equalTo(self.bodyView).offset(0);
        make.right.mas_equalTo(self.model.cpnConfig.dataSource ? self.suffixView.mas_left : self.bodyView).offset(0);
    }];

    if (![self.ctnView.subviews containsObject:self.prefixLabel]) {
        [self.ctnView addSubview:self.prefixLabel];
    }
    [self.prefixLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.ctnView);
        make.left.mas_equalTo(self.ctnView).offset(10);
    }];

    if (![self.ctnView.subviews containsObject:self.suffixLabel]) {
        [self.ctnView addSubview:self.suffixLabel];
    }
    [self.suffixLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.ctnView);
        make.right.mas_equalTo(self.ctnView).offset(-10);
    }];

    // textField
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.ctnView).offset(0);
        make.left.mas_equalTo(self.prefixLabel.mas_right).offset(5);
        make.right.mas_equalTo(self.suffixLabel.mas_left).offset(-5);
        make.height.mas_equalTo(kIMSFormDefaultHeight);
    }];
    [self.textField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.textField setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!self.model.isEditable) {
        return NO;
    }

    // limit number precision
    if (![self validateNumberWithTextField:textField changeRange:range withString:string]) {
        return NO;
    }

    BOOL returnKey = [string rangeOfString:@"\n"].location != NSNotFound;

    // update model value
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.model.value = [NSString getRoundFloat:[str floatValue] withPrecisionNum:self.model.cpnConfig.precision];

    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }

    return ([str floatValue] >= self.model.cpnConfig.min && [str floatValue] <= self.model.cpnConfig.max) || returnKey;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    // text type limit, blur 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Blur]) {
        [self validate];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.model.value = @"";

    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.model.value = [NSString getRoundFloat:[textField.text floatValue] withPrecisionNum:self.model.cpnConfig.precision];
    textField.text = self.model.value;
}

#pragma mark - Private Methods

- (BOOL)validateNumberWithTextField:(UITextField *)textField changeRange:(NSRange)range withString:(NSString *)replacementString {
    // “-” 必须是第一个位置也可保证只有一个 “-”
    if ([replacementString isEqualToString:@"-"]) {
        if (range.location != 0) {
            return NO;
        }
    }
    //只允许输入一个小数点
    if ([textField.text containsString:@"."] && [replacementString isEqualToString:@"."]) {
        return NO;
    }
    //小数点不能为第一位
    if (textField.text.length == 0 && [replacementString isEqualToString:@"."]) {
        return NO;
    }
    //限制小数点后只能输一位数字
    NSArray *arrStr = [[textField.text stringByAppendingString:replacementString] componentsSeparatedByString:@"."];
    if (arrStr.count > 1) {
        NSString *str1 = arrStr.lastObject;
        if (str1.length > self.model.cpnConfig.precision) {
            return NO;
        }
    }
    //限制只能输入 "-0123456789."
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789."];
    //if (textField == self.moneyTF) {//如果是后面那个输入金额的textFiled则限制 限制只能输入 "-0123456789"
    // tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"-0123456789"];
    //}
    BOOL res = YES;
    int i = 0;
    while (i < replacementString.length) {
        NSString *string = [replacementString substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

// 清除重用数据
- (void)clearReuseData
{
    self.titleLabel.text = @"";
    self.textField.text = @"";
    self.textField.placeholder = @"";
    self.infoLabel.text = @"";
    self.prefixLabel.text = @"";
    self.suffixLabel.text = @"";
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];

    [self updateUI];

    [self clearReuseData];
    [self setTitle:model.title required:model.isRequired];
    
    // update default value
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected = YES"];
    NSArray *resultArray = [self.model.cpnConfig.dataSource filteredArrayUsingPredicate:predicate];
    if (resultArray && resultArray.count > 0) {
        self.model.valueList = [NSMutableArray arrayWithObjects:resultArray.firstObject, nil];
    }

    CGFloat value = MAX(self.model.value.floatValue, self.model.cpnConfig.min);
    value = MIN(value, self.model.cpnConfig.max);
    self.textField.text = [NSString getRoundFloat:value withPrecisionNum:self.model.cpnConfig.precision];
    self.textField.placeholder = model.placeholder ? : @"Please enter";

    self.infoLabel.text = model.info;

    // MARK: 显示已选中的值/默认值
    if (self.model.valueList && self.model.valueList.count > 0) {
        IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:[self.model.valueList firstObject]];
        self.suffixView.textLabel.text = selectedModel.label;
    } else {
        if (self.model.cpnConfig && self.model.cpnConfig.dataSource.count > 0) {
            IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:[self.model.cpnConfig.dataSource firstObject]];
            self.suffixView.textLabel.text = selectedModel.label;
            self.model.valueList = [@[[selectedModel yy_modelToJSONObject]] mutableCopy];
        } else {
            self.suffixView.textLabel.text = @"N/A";
        }
    }

    if (self.model.cpnConfig.prefixUnit) {
        self.prefixLabel.text = self.model.cpnConfig.prefixUnit;
    }

    if (self.model.cpnConfig.suffixUnit) {
        self.suffixLabel.text = self.model.cpnConfig.suffixUnit;
    } else {
        IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:[self.model.valueList firstObject]];
        self.suffixLabel.text = selectedModel.value;
    }

//    [self layoutIfNeeded];
}

#pragma mark - Getters

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"Please enter";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:12];
    }
    return _textField;
}

- (IMSFormSelectView *)suffixView
{
    if (!_suffixView) {
        _suffixView = [[IMSFormSelectView alloc] init];
        @weakify(self);
        _suffixView.didSelectBlock = ^(id _Nonnull obj) {
            @strongify(self);
            [self.textField endEditing:YES];

            if (!self->_suffixSingleSelectListView) {
                if (self.form.uiDelegate && [self.form.uiDelegate respondsToSelector:NSSelectorFromString(@"customSuffixTextFieldCellSelectListViewWithFormModel:")]) {
                    self->_suffixSingleSelectListView = [self.form.uiDelegate customSuffixTextFieldCellSelectListViewWithFormModel:self.model];
                }
            }
            if (!self.form || !self->_suffixSingleSelectListView) {
                [self.suffixSingleSelectListView setDataArray:self.model.cpnConfig.dataSource type:IMSPopupSingleSelectListViewCellType_Default];
            }

            @weakify(self);
            [self.suffixSingleSelectListView setDidSelectedBlock:^(NSArray *_Nonnull dataArray, IMSFormSelect *_Nonnull selectedModel) {
                @strongify(self);
                self.suffixView.textLabel.text = selectedModel.label;
                self.suffixLabel.text = self.model.cpnConfig.suffixUnit ? : selectedModel.value;
                self.model.valueList = [@[[selectedModel yy_modelToJSONObject]] mutableCopy];
            }];

            [self.suffixSingleSelectListView setDidFinishedShowAndHideBlock:^(BOOL isShow) {
                @strongify(self);
                // update model value
                self.suffixView.selected = isShow;

                // call back
                if (!isShow && self.didUpdateFormModelBlock) {
                    self.didUpdateFormModelBlock(self, self.model, nil);
                }
            }];

            self.suffixSingleSelectListView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);

            [self.suffixSingleSelectListView showView];
        };
    }
    return _suffixView;
}

- (IMSPopupSingleSelectListView *)suffixSingleSelectListView {
    if (_suffixSingleSelectListView == nil) {
        _suffixSingleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
    }
    return _suffixSingleSelectListView;
}

- (UILabel *)prefixLabel {
    if (_prefixLabel == nil) {
        _prefixLabel = [[UILabel alloc] init];
        _prefixLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _prefixLabel.font = [UIFont systemFontOfSize:12];
        _prefixLabel.backgroundColor = [UIColor clearColor];
    }
    return _prefixLabel;
}

- (UILabel *)suffixLabel {
    if (_suffixLabel == nil) {
        _suffixLabel = [[UILabel alloc] init];
        _suffixLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _suffixLabel.font = [UIFont systemFontOfSize:12];
        _suffixLabel.backgroundColor = [UIColor clearColor];
    }
    return _suffixLabel;
}

- (UIView *)ctnView
{
    if (!_ctnView) {
        _ctnView = [[UIView alloc] init];
    }
    return _ctnView;
}

@end
