//
//  IMSFormPhoneCell.m
//  IMSForm
//
//  Created by cjf on 28/1/2021.
//

#import "IMSFormPhoneCell.h"
#import <IMSForm/IMSFormManager.h>
#import <IMSForm/IMSFormSelectView.h>
#import <IMSForm/IMSPopupSingleSelectListView.h>

@interface IMSFormPhoneCell () <UITextFieldDelegate>

@property (strong, nonatomic) IMSFormSelectView *prefixView; /**< <#property#> */
@property (nonatomic, strong) IMSPopupSingleSelectListView *prefixSingleSelectListView; /**< <#property#> */

@property (strong, nonatomic) UIView *ctnView; /**< <#property#> */
@property (strong, nonatomic) UILabel *prefixLabel; /**< <#property#> */
@property (strong, nonatomic) UILabel *suffixLabel; /**< <#property#> */

@end

@implementation IMSFormPhoneCell

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
    
    if (self.model.isEditable) {
        self.textField.keyboardType = [self keyboardWithTextType:IMSFormTextType_Phone];
    }
    
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
    
//    [self.form.tableView beginUpdates];
//    [self.form.tableView endUpdates];
}

- (void)buildBodyViewSubViews
{
    // prefixView
//    if (self.model.cpnConfig.dataSource) {
        if (![self.bodyView.subviews containsObject:self.prefixView]) {
            [self.bodyView addSubview:self.prefixView];
        }
        [self.prefixView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self.bodyView);
            make.width.mas_lessThanOrEqualTo(150);
        }];
        [self.prefixView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        self.prefixView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
//    } else {
//        [self.prefixView removeFromSuperview];
//    }
    
    [self.ctnView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.bodyView);
        make.left.mas_equalTo(self.model.cpnConfig.dataSource ? self.prefixView.mas_right : self.bodyView).offset(0);
        make.right.mas_equalTo(self.bodyView).offset(0);
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
    
    // length limit
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    // update model value
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.model.value = str;
    
    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }
    
    return newLength <= self.model.cpnConfig.lengthLimit || returnKey;
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
    
    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }
    
    return YES;
}

#pragma mark - Private Methods

// 清除重用数据
- (void)clearReuseData
{
    self.titleLabel.text = @"";
    self.infoLabel.text = @"";
    self.textField.text = @"";
    self.textField.placeholder = @"Please enter";
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
    
    self.textField.text = [model.value substringWithRange:NSMakeRange(0, MIN(model.value.length, self.model.cpnConfig.lengthLimit))];
    self.textField.placeholder = model.placeholder ? : @"Please enter";
    
    self.infoLabel.text = model.info;
    
    // 显示已选中值/默认值
    if (self.model.valueList && self.model.valueList.count > 0) {
        IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:[self.model.valueList firstObject]];
        self.prefixView.textLabel.text = selectedModel.label;
    } else {
        if (self.model.cpnConfig.dataSource && self.model.cpnConfig.dataSource.count > 0) {
            IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:[self.model.cpnConfig.dataSource firstObject]];
            self.prefixView.textLabel.text = selectedModel.label;
            self.model.valueList = @[[selectedModel yy_modelToJSONObject]];
        } else {
            self.prefixView.textLabel.text = @"N/A";
        }
    }
    
    if (self.model.cpnConfig.prefixUnit) {
        self.prefixLabel.text = self.model.cpnConfig.prefixUnit;
    } else {
        IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:[self.model.valueList firstObject]];
        self.prefixLabel.text = selectedModel.value;
    }
    
    if (self.model.cpnConfig.suffixUnit) {
        self.suffixLabel.text = self.model.cpnConfig.suffixUnit;
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
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:12];
    }
    return _textField;
}

- (IMSFormSelectView *)prefixView
{
    if (!_prefixView) {
        _prefixView = [[IMSFormSelectView alloc] init];
        @weakify(self);
        _prefixView.didSelectBlock = ^(id  _Nonnull obj) {
            @strongify(self);
            [self.textField endEditing:YES];
            
            if (!self->_prefixSingleSelectListView) {
                if (self.form.uiDelegate && [self.form.uiDelegate respondsToSelector:NSSelectorFromString(@"customPrefixTextFieldCellSelectListViewWithFormModel:")]) {
                    self->_prefixSingleSelectListView = [self.form.uiDelegate customPrefixTextFieldCellSelectListViewWithFormModel:self.model];
                }
            }
            if (!self.form || !self->_prefixSingleSelectListView) {
                [self.prefixSingleSelectListView setDataArray:self.model.cpnConfig.dataSource type:IMSPopupSingleSelectListViewCellType_Default];
            }
            
            @weakify(self);
            [self.prefixSingleSelectListView setDidSelectedBlock:^(NSArray * _Nonnull dataArray, IMSFormSelect * _Nonnull selectedModel) {
                @strongify(self);
                self.prefixView.textLabel.text = selectedModel.label;
                self.prefixLabel.text = self.model.cpnConfig.prefixUnit ? : selectedModel.value;
                self.model.valueList = [@[[selectedModel yy_modelToJSONObject]] mutableCopy];
            }];
            
            [self.prefixSingleSelectListView setDidFinishedShowAndHideBlock:^(BOOL isShow) {
                @strongify(self);
                // update model value
                self.prefixView.selected = isShow;
                
                // call back
                if (!isShow && self.didUpdateFormModelBlock) {
                    self.didUpdateFormModelBlock(self, self.model, nil);
                }
            }];
            
            self.prefixSingleSelectListView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
            
            [self.prefixSingleSelectListView showView];
        };
    }
    return _prefixView;
}

- (IMSPopupSingleSelectListView *)prefixSingleSelectListView {
    if (_prefixSingleSelectListView == nil) {
        _prefixSingleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
    }
    return _prefixSingleSelectListView;
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
