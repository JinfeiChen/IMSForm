//
//  IMSFormTextFieldCell.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormTextFieldCell.h"
#import <IMSForm/IMSFormManager.h>
#import <IMSForm/IMSFormSelectView.h>
#import <IMSForm/IMSPopupSingleSelectListView.h>

@interface IMSFormTextFieldCell () <UITextFieldDelegate>

@property (strong, nonatomic) IMSFormSelectView *prefixView; /**< <#property#> */
@property (strong, nonatomic) IMSFormSelectView *suffixView; /**< <#property#> */
@property (nonatomic, strong) IMSPopupSingleSelectListView *prefixSingleSelectListView; /**< <#property#> */
@property (nonatomic, strong) IMSPopupSingleSelectListView *suffixSingleSelectListView; /**< <#property#> */

@property (strong, nonatomic) UIView *ctnView; /**< <#property#> */
@property (strong, nonatomic) UILabel *prefixLabel; /**< <#property#> */
@property (strong, nonatomic) UILabel *suffixLabel; /**< <#property#> */

@end

@implementation IMSFormTextFieldCell

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
        self.textField.keyboardType = [self keyboardWithTextType:self.model.cpnConfig.textType];
        self.textField.secureTextEntry = [self.model.cpnConfig.textType isEqualToString:IMSFormTextType_Password];
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
    if (self.model.prefixModel) {
        if (![self.bodyView.subviews containsObject:self.prefixView]) {
            [self.bodyView addSubview:self.prefixView];
        }
        [self.prefixView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self.bodyView);
            make.width.mas_lessThanOrEqualTo(100);
        }];
        [self.prefixView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        self.prefixView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
    } else {
        [self.prefixView removeFromSuperview];
    }
    
    // suffixView
    if (self.model.suffixModel) {
        if (![self.bodyView.subviews containsObject:self.suffixView]) {
            [self.bodyView addSubview:self.suffixView];
        }
        [self.suffixView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(self.bodyView);
            make.width.mas_lessThanOrEqualTo(100);
        }];
        [self.suffixView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        self.suffixView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
    } else {
        [self.suffixView removeFromSuperview];
    }
    
    [self.ctnView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.bodyView);
        make.left.mas_equalTo(self.model.prefixModel ? self.prefixView.mas_right : self.bodyView).offset(0);
        make.right.mas_equalTo(self.model.suffixModel ? self.suffixView.mas_left : self.bodyView).offset(0);
    }];
    
    if (self.model.cpnConfig.prefixUnit) {
        if (![self.ctnView.subviews containsObject:self.prefixLabel]) {
            [self.ctnView addSubview:self.prefixLabel];
        }
        [self.prefixLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.ctnView);
            make.left.mas_equalTo(self.ctnView).offset(10);
        }];
    } else {
        [self.prefixLabel removeFromSuperview];
    }

    if (self.model.cpnConfig.suffixUnit) {
        if (![self.ctnView.subviews containsObject:self.suffixLabel]) {
            [self.ctnView addSubview:self.suffixLabel];
        }
        [self.suffixLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.ctnView);
            make.right.mas_equalTo(self.ctnView).offset(-10);
        }];
    } else {
        [self.suffixLabel removeFromSuperview];
    }

    // textField
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.ctnView).offset(0);
        make.left.mas_equalTo(self.model.cpnConfig.prefixUnit ? self.prefixLabel.mas_right : self.ctnView).offset(5);
        make.right.mas_equalTo(self.model.cpnConfig.suffixUnit ? self.suffixLabel.mas_left : self.ctnView).offset(-5);
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
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormTextFieldModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self clearReuseData];
    [self setTitle:model.title required:model.isRequired];
    
    self.textField.text = [model.value substringWithRange:NSMakeRange(0, MIN(model.value.length, self.model.cpnConfig.lengthLimit))];
    self.textField.placeholder = model.placeholder ? : @"Please enter";
    
    self.infoLabel.text = model.info;
    
    if (model.prefixModel && model.prefixModel.valueList.count > 0) {
        IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:[model.prefixModel.valueList firstObject]];
        self.prefixView.textLabel.text = selectedModel.value;
    }
    
    if (model.suffixModel && model.suffixModel.valueList.count > 0) {
        IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:[model.suffixModel.valueList firstObject]];
        self.suffixView.textLabel.text = selectedModel.value;
    }
    
    if (model.cpnConfig.prefixUnit) {
        self.prefixLabel.text = model.cpnConfig.prefixUnit;
        
//        YYLabel *contentL = [[YYLabel alloc] init];
//        //计算标题文本尺寸
//        NSMutableAttributedString *titleAttri = [[NSMutableAttributedString alloc] initWithString:model.cpnConfig.prefixUnit];
//        CGSize maxSize = CGSizeMake(MAXFLOAT, kIMSFormDefaultHeight);
//        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:titleAttri];
//        contentL.textLayout = layout;
//        CGFloat prefixUnitWidth = layout.textBoundingSize.width;
//        [self.textField setValue:[NSNumber numberWithFloat:(prefixUnitWidth + 8)] forKey:@"paddingLeft"];
//
//        if (![self.bodyView.subviews containsObject:self.prefixLabel]) {
//            [self.bodyView addSubview:self.prefixLabel];
//        }
//        [self.prefixLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.mas_equalTo(self.textField);
//        }];
    }
    
    if (model.cpnConfig.suffixUnit) {
        self.suffixLabel.text = model.cpnConfig.suffixUnit;
        
//        YYLabel *contentL = [[YYLabel alloc] init];
//        //计算标题文本尺寸
//        NSMutableAttributedString *titleAttri = [[NSMutableAttributedString alloc] initWithString:model.cpnConfig.suffixUnit];
//        CGSize maxSize = CGSizeMake(MAXFLOAT, kIMSFormDefaultHeight);
//        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:titleAttri];
//        contentL.textLayout = layout;
//        CGFloat prefixUnitWidth = layout.textBoundingSize.width;
////        [self.textField setValue:[NSNumber numberWithFloat:(prefixUnitWidth + 8)] forKey:@"paddingRight"];
//
//        if (![self.bodyView.subviews containsObject:self.suffixLabel]) {
//            [self.bodyView addSubview:self.suffixLabel];
//        }
//        [self.suffixLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.bottom.mas_equalTo(self.textField);
//        }];
    }
    
    [self layoutIfNeeded];
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
        _textField.font = [UIFont systemFontOfSize:14];
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
                [self.prefixSingleSelectListView setDataArray:self.model.prefixModel.cpnConfig.dataSource type:IMSPopupSingleSelectListViewCellType_Default];
            }
            
            @weakify(self);
            [self.prefixSingleSelectListView setDidSelectedBlock:^(NSArray * _Nonnull dataArray, IMSFormSelect * _Nonnull selectedModel) {
                @strongify(self);
                NSLog(@"%@, %@", dataArray, [selectedModel yy_modelToJSONObject]);
                
                self.prefixView.textLabel.text = selectedModel.value;
                self.model.prefixModel.valueList = [@[[selectedModel yy_modelToJSONObject]] mutableCopy];
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

- (IMSFormSelectView *)suffixView
{
    if (!_suffixView) {
        _suffixView = [[IMSFormSelectView alloc] init];
        @weakify(self);
        _suffixView.didSelectBlock = ^(id  _Nonnull obj) {
            @strongify(self);
            [self.textField endEditing:YES];
            
            if (!self->_suffixSingleSelectListView) {
                if (self.form.uiDelegate && [self.form.uiDelegate respondsToSelector:NSSelectorFromString(@"customSuffixTextFieldCellSelectListViewWithFormModel:")]) {
                    self->_suffixSingleSelectListView = [self.form.uiDelegate customSuffixTextFieldCellSelectListViewWithFormModel:self.model];
                }
            }
            if (!self.form || !self->_suffixSingleSelectListView) {
                [self.suffixSingleSelectListView setDataArray:self.model.suffixModel.cpnConfig.dataSource type:IMSPopupSingleSelectListViewCellType_Default];
            }
            
            @weakify(self);
            [self.suffixSingleSelectListView setDidSelectedBlock:^(NSArray * _Nonnull dataArray, IMSFormSelect * _Nonnull selectedModel) {
                @strongify(self);
                NSLog(@"%@, %@", dataArray, [selectedModel yy_modelToJSONObject]);
                
                self.suffixView.textLabel.text = selectedModel.value;
                self.model.suffixModel.valueList = [@[[selectedModel yy_modelToJSONObject]] mutableCopy];
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

- (IMSPopupSingleSelectListView *)prefixSingleSelectListView {
    if (_prefixSingleSelectListView == nil) {
        _prefixSingleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
    }
    return _prefixSingleSelectListView;
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
        _prefixLabel.font = [UIFont systemFontOfSize:14];
        _prefixLabel.backgroundColor = [UIColor clearColor];
    }
    return _prefixLabel;
}

- (UILabel *)suffixLabel {
    if (_suffixLabel == nil) {
        _suffixLabel = [[UILabel alloc] init];
        _suffixLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _suffixLabel.font = [UIFont systemFontOfSize:14];
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


