//
//  IMSFormMultiTextFieldCell.m
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import "IMSFormMultiTextFieldCell.h"
#import <IMSForm/IMSFormManager.h>

#import <IMSForm/IMSFormSelectView.h>
#import <IMSForm/IMSPopupSingleSelectListView.h>

#define kFormTBMultiTextFieldItemHeight 40.0

@interface IMSFormMultiTextFieldItemCell : IMSFormTableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) UIButton *deleteBtn; /**< <#property#> */
@property (strong, nonatomic) UITextField *textField;
@property (copy, nonatomic) void (^ deleteBlock)(UIButton *button); /**< <#property#> */
@property (copy, nonatomic) void (^ didEndEditingBlock)(UITextField *textField); /**< <#property#> */
@property (copy, nonatomic) void (^ didSelectedAtPrefixViewBlock)(id data); /**< <#property#> */
@property (copy, nonatomic) void (^ didSelectedAtSuffixViewBlock)(id data); /**< <#property#> */

@property (strong, nonatomic) IMSFormSelectView *prefixView; /**< <#property#> */
@property (strong, nonatomic) IMSFormSelectView *suffixView; /**< <#property#> */
@property (nonatomic, strong) IMSPopupSingleSelectListView *prefixSingleSelectListView; /**< <#property#> */
@property (nonatomic, strong) IMSPopupSingleSelectListView *suffixSingleSelectListView; /**< <#property#> */

@property (strong, nonatomic) UIView *ctnView; /**< <#property#> */
@property (strong, nonatomic) UILabel *prefixLabel; /**< <#property#> */
@property (strong, nonatomic) UILabel *suffixLabel; /**< <#property#> */

@property (assign, nonatomic) BOOL showPrefixView; /**< <#property#> */
@property (assign, nonatomic) BOOL showSuffixView; /**< <#property#> */

@property (copy, nonatomic) NSString *prefixUnit; /**< <#property#> */
@property (copy, nonatomic) NSString *suffixUnit; /**< <#property#> */

@property (strong, nonatomic) IMSFormSelect *selectedPrefixModel; /**< <#property#> */
@property (strong, nonatomic) IMSFormSelect *selectedSuffixModel; /**< <#property#> */

@property (strong, nonatomic) IMSFormMultiTextFieldModel *model; /**< <#property#> */

@end

@implementation IMSFormMultiTextFieldItemCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildView];
        
        __weak __typeof__(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
            __typeof__(self) strongSelf = weakSelf;
            if (note.object == strongSelf.textField) {
                // call back
                if (self.didEndEditingBlock) {
                    self.didEndEditingBlock(self.textField);
                }
            }
        }];
    }
    return self;
}

#pragma mark - UI

- (void)buildView
{
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.bodyView];
    [self.bodyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.bodyView addSubview:self.ctnView];
    [self.ctnView addSubview:self.textField];
    
    [self updateUI];
}

- (void)updateUI
{
    CGFloat spacing = self.model.cpnStyle.spacing;

    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kFormTBMultiTextFieldItemHeight-5, kFormTBMultiTextFieldItemHeight-5));
        make.top.mas_equalTo(self.contentView).offset(2.5);
        make.bottom.right.mas_equalTo(self.contentView).offset(-2.5);
        make.right.mas_equalTo(self.contentView).offset(0);
    }];

    [self.bodyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(0);
        make.right.mas_equalTo(self.deleteBtn.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kFormTBMultiTextFieldItemHeight - 5);
    }];
        
    [self buildBodyViewSubViews];

}

- (void)buildBodyViewSubViews
{
    // prefixView
    if (self.showPrefixView) {
        if (![self.bodyView.subviews containsObject:self.prefixView]) {
            [self.bodyView addSubview:self.prefixView];
        }
        [self.prefixView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self.bodyView);
            make.width.mas_lessThanOrEqualTo(100);
        }];
        [self.prefixView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    } else {
        [self.prefixView removeFromSuperview];
    }
    
    // suffixView
    if (self.showSuffixView) {
        if (![self.bodyView.subviews containsObject:self.suffixView]) {
            [self.bodyView addSubview:self.suffixView];
        }
        [self.suffixView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(self.bodyView);
            make.width.mas_lessThanOrEqualTo(100);
        }];
        [self.suffixView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    } else {
        [self.suffixView removeFromSuperview];
    }
    
    [self.ctnView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.bodyView);
        make.left.mas_equalTo(self.showPrefixView ? self.prefixView.mas_right : self.bodyView).offset(0);
        make.right.mas_equalTo(self.showSuffixView ? self.suffixView.mas_left : self.bodyView).offset(0);
    }];
    
    if (self.prefixUnit) {
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

    if (self.suffixUnit) {
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
        make.left.mas_equalTo(self.prefixUnit ? self.prefixLabel.mas_right : self.ctnView).offset(5);
        make.right.mas_equalTo(self.suffixUnit ? self.suffixLabel.mas_left : self.ctnView).offset(-5);
        make.height.mas_equalTo(kIMSFormDefaultHeight);
    }];
    [self.textField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.textField setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
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

#pragma mark - Actions

- (void)deleteBtnAction:(UIButton *)button
{
    if (self.deleteBlock) {
        self.deleteBlock(button);
    }
}

#pragma mark - Setters

- (void)setModel:(IMSFormMultiTextFieldModel *)model
{
    _model = model;
    
    self.textField.text = [NSString stringWithFormat:@"%@", model.value ? : @""];
    
    // prefix
    self.showPrefixView = (model.cpnConfig.prefixDataSource && model.cpnConfig.prefixDataSource.count > 0);
    
    if (self.showPrefixView) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.selected = YES"];
        NSArray *resultArray = [model.cpnConfig.prefixDataSource filteredArrayUsingPredicate:predicate];
        if (resultArray && resultArray.count > 0) {
            IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:resultArray.firstObject];
            self.selectedPrefixModel = selectedModel;
            self.prefixView.textLabel.text = selectedModel.label;
        } else {
            resultArray = model.cpnConfig.prefixDataSource;
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:model.cpnConfig.prefixDataSource];
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:mArr.firstObject];
            [mDict setValue:@(YES) forKey:@"selected"];
            [mArr replaceObjectAtIndex:0 withObject:mDict];
            model.cpnConfig.prefixDataSource = mArr;
            IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:resultArray.firstObject];
            self.selectedPrefixModel = selectedModel;
            self.prefixView.textLabel.text = selectedModel.label;
        }
    }
    
    // suffix
    self.showSuffixView = (model.cpnConfig.suffixDataSource && model.cpnConfig.suffixDataSource.count > 0);
    
    if (self.showSuffixView) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.selected = YES"];
        NSArray *resultArray = [model.cpnConfig.suffixDataSource filteredArrayUsingPredicate:predicate];
        if (resultArray && resultArray.count > 0) {
            IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:resultArray.firstObject];
            self.selectedSuffixModel = selectedModel;
            self.suffixView.textLabel.text = selectedModel.label;
        } else {
            resultArray = model.cpnConfig.suffixDataSource;
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:model.cpnConfig.suffixDataSource];
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:mArr.firstObject];
            [mDict setValue:@(YES) forKey:@"selected"];
            [mArr replaceObjectAtIndex:0 withObject:mDict];
            model.cpnConfig.suffixDataSource = mArr;
            IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:resultArray.firstObject];
            self.selectedSuffixModel = selectedModel;
            self.suffixView.textLabel.text = selectedModel.label;
        }
    }
    
    [self updateUI];
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
            
            if (self.didSelectedAtPrefixViewBlock) {
                self.didSelectedAtPrefixViewBlock(nil);
            }
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
            
            if (self.didSelectedAtSuffixViewBlock) {
                self.didSelectedAtSuffixViewBlock(nil);
            }
        };
    }
    return _suffixView;
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

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage bundleImageWithNamed:@"search_clean"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.layer.cornerRadius = kIMSFormDefaultHeight / 2;
        _deleteBtn.layer.masksToBounds = YES;
    }
    return _deleteBtn;
}

@end




@interface IMSFormMultiTextFieldCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IMSPopupSingleSelectListView *prefixSingleSelectListView; /**< <#property#> */
@property (nonatomic, strong) IMSPopupSingleSelectListView *suffixSingleSelectListView; /**< <#property#> */

@end

@implementation IMSFormMultiTextFieldCell

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
    [self.bodyView addSubview:self.addButton];
    [self.bodyView addSubview:self.listTableView];
    
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
    self.bodyView.backgroundColor = self.contentView.backgroundColor;
    self.bodyView.layer.cornerRadius = 0.0;
    self.bodyView.layer.masksToBounds = YES;
    self.listTableView.backgroundColor = self.contentView.backgroundColor;
    [self.addButton setBackgroundColor:self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor];
    
    CGFloat spacing = self.model.cpnStyle.spacing;
    // 只支持竖向布局
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.top);
        make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
        make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
    }];
    [self.bodyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(spacing);
        make.left.equalTo(self.contentView).offset(self.model.cpnStyle.contentInset.left);
        make.right.equalTo(self.contentView).offset(-self.model.cpnStyle.contentInset.right);
    }];
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.bodyView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
    }];
    
    [self.addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, kIMSFormDefaultHeight));
        make.left.bottom.mas_equalTo(self.bodyView).offset(0);
    }];
    [self.listTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.addButton.mas_bottom).offset(spacing).priorityLow();
        make.top.mas_equalTo(self.bodyView).offset(0);
        make.left.right.mas_equalTo(self.bodyView).offset(0);
        make.bottom.mas_equalTo(self.addButton.mas_top).offset(-spacing).priorityLow(); // 消除控制台中提示约束重载的冲突
    }];
}

- (void)updateMyConstraints
{
    [self.listTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.addButton.mas_top).offset(-(self.model.valueList.count > 0 ? self.model.cpnStyle.spacing : 0));
    }];
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormMultiTextFieldModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self clearReuseData];
    [self setTitle:model.title required:model.isRequired];

    [self.addButton setTitle:model.cpnConfig.addButtonTitle?:@"Add More" forState:UIControlStateNormal];
    self.infoLabel.text = model.info;
    
    // update default value
    self.model.valueList = [[model.valueList subarrayWithRange:NSMakeRange(0, MIN(model.valueList.count, self.model.cpnConfig.maxLimit))] mutableCopy];
    
    if (self.model.isEditable) {
        self.addButton.enabled = (self.model.valueList.count < self.model.cpnConfig.maxLimit);
    } else {
        self.addButton.enabled = NO;
    }
    
    [self.listTableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MIN(self.model.valueList.count, self.model.cpnConfig.maxLimit);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMSFormMultiTextFieldItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSFormMultiTextFieldItemCell class])];
    NSDictionary *modelDict = self.model.valueList[indexPath.row];
    cell.model = [IMSFormMultiTextFieldModel yy_modelWithDictionary:modelDict];
    
    cell.textField.placeholder = self.model.placeholder ? : @"Please enter";
//    cell.deleteBtn.hidden = !self.model.isEditable;
    cell.deleteBtn.enabled = !self.model.isEditable;
    cell.contentView.backgroundColor = self.bodyView.backgroundColor;
    cell.bodyView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    cell.deleteBtn.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    cell.prefixView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
    cell.suffixView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
    
    @weakify(self);
    cell.deleteBlock = ^(UIButton *button) {
        @strongify(self);
        
        // MARK: delete file
        [self.model.valueList removeObjectAtIndex:indexPath.row];
        self.addButton.enabled = (self.model.valueList.count < self.model.cpnConfig.maxLimit);
        [self updateMyConstraints];
        
        [self.listTableView reloadData];
        [self.form.tableView beginUpdates];
        [self.form.tableView endUpdates];
        
        // call back
        if (self.didUpdateFormModelBlock) {
            self.didUpdateFormModelBlock(self, self.model, nil);
        }
    };
    cell.didEndEditingBlock = ^(UITextField *textField) {
        @strongify(self);
        NSMutableDictionary *mModelDict = [NSMutableDictionary dictionaryWithDictionary:self.model.valueList[indexPath.row]];
        [mModelDict setValue:textField.text forKey:@"value"];
        [self.model.valueList replaceObjectAtIndex:indexPath.row withObject:mModelDict];
    };
    cell.didSelectedAtPrefixViewBlock = ^(id data) {
        @strongify(self);
        
        self.prefixSingleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
        if (!self->_prefixSingleSelectListView) {
            if (self.form.uiDelegate && [self.form.uiDelegate respondsToSelector:NSSelectorFromString(self.model.cpnConfig.prefixCustomSelector)]) {
                self->_prefixSingleSelectListView = [self.form.uiDelegate customPrefixTextFieldCellSelectListViewWithFormModel:self.model];
            }
        }
        [self.prefixSingleSelectListView setDataArray:cell.model.cpnConfig.prefixDataSource type:IMSPopupSingleSelectListViewCellType_Default];
        
        [self.prefixSingleSelectListView setDidSelectedBlock:^(NSArray * _Nonnull dataArray, IMSFormSelect * _Nonnull selectedModel) {
            NSLog(@"%@, %@", dataArray, [selectedModel yy_modelToJSONObject]);
            
            cell.model.cpnConfig.prefixDataSource = dataArray;
            cell.selectedPrefixModel = selectedModel;
            cell.prefixView.textLabel.text = selectedModel.label;
            [self.model.valueList replaceObjectAtIndex:indexPath.row withObject:[cell.model yy_modelToJSONObject]];
        }];
        
        [self.prefixSingleSelectListView setDidFinishedShowAndHideBlock:^(BOOL isShow) {
            // update model value
            cell.prefixView.selected = isShow;
            
            // call back
            if (!isShow && self.didUpdateFormModelBlock) {
                self.didUpdateFormModelBlock(self, self.model, nil);
            }
        }];
        
        self.prefixSingleSelectListView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
        
        [self.prefixSingleSelectListView showView];
        
    };
    cell.didSelectedAtSuffixViewBlock = ^(id data) {
        @strongify(self);
        
        self.suffixSingleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
        if (!self->_suffixSingleSelectListView) {
            if (self.form.uiDelegate && [self.form.uiDelegate respondsToSelector:NSSelectorFromString(self.model.cpnConfig.suffixCustomSelector)]) {
                self->_suffixSingleSelectListView = [self.form.uiDelegate customSuffixTextFieldCellSelectListViewWithFormModel:self.model];
            }
        }
        [self.suffixSingleSelectListView setDataArray:cell.model.cpnConfig.suffixDataSource type:IMSPopupSingleSelectListViewCellType_Default];
        
        [self.suffixSingleSelectListView setDidSelectedBlock:^(NSArray * _Nonnull dataArray, IMSFormSelect * _Nonnull selectedModel) {
            NSLog(@"%@, %@", dataArray, [selectedModel yy_modelToJSONObject]);
            
            cell.model.cpnConfig.suffixDataSource = dataArray;
            cell.selectedSuffixModel = selectedModel;
            cell.suffixView.textLabel.text = selectedModel.label;
            [self.model.valueList replaceObjectAtIndex:indexPath.row withObject:[cell.model yy_modelToJSONObject]];
        }];
        
        [self.suffixSingleSelectListView setDidFinishedShowAndHideBlock:^(BOOL isShow) {
            // update model value
            cell.suffixView.selected = isShow;
            
            // call back
            if (!isShow && self.didUpdateFormModelBlock) {
                self.didUpdateFormModelBlock(self, self.model, nil);
            }
        }];
        
        self.suffixSingleSelectListView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
        
        [self.suffixSingleSelectListView showView];
        
    };
    return cell;
}

#pragma mark - UIView (UIConstraintBasedLayoutFittingSize)

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    if (!self.model) {
        return targetSize;
    }
    
    self.listTableView.frame = CGRectMake(0, 0, targetSize.width, 44);
    [self.listTableView layoutIfNeeded];
    
    YYLabel *contentL = [[YYLabel alloc] init];
    //计算标题文本尺寸
    NSMutableAttributedString *titleAttri = [[NSMutableAttributedString alloc] initWithString:self.model.title];
    CGSize maxSize = CGSizeMake(targetSize.width - self.model.cpnStyle.contentInset.left - self.model.cpnStyle.contentInset.right, MAXFLOAT);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:titleAttri];
    contentL.textLayout = layout;
    CGFloat titleHeight = layout.textBoundingSize.height < 15 ? layout.textBoundingSize.height : 15;
    
    NSMutableAttributedString *infoAttri = [[NSMutableAttributedString alloc] initWithString:self.model.info];
    maxSize = CGSizeMake(targetSize.width - self.model.cpnStyle.contentInset.left - self.model.cpnStyle.contentInset.right, MAXFLOAT);
    layout = [YYTextLayout layoutWithContainerSize:maxSize text:infoAttri];
    contentL.textLayout = layout;
    CGFloat infoHeight = layout.textBoundingSize.height;
    
    CGFloat spacingHeight = self.model.cpnStyle.spacing * ((self.model.valueList.count > 0) ? 2 : 1) + 10;
    CGFloat buttonHeight = kIMSFormDefaultHeight;
    NSInteger count = MIN(self.model.valueList.count, self.model.cpnConfig.maxLimit);
    CGFloat contentViewHeight = kFormTBMultiTextFieldItemHeight * count + self.model.cpnStyle.contentInset.top + self.model.cpnStyle.contentInset.bottom + titleHeight + self.listTableView.contentInset.top + self.listTableView.contentInset.bottom + spacingHeight + buttonHeight + infoHeight;
    return CGSizeMake(targetSize.width, contentViewHeight);
}

#pragma mark - Private Methods

// 清除重用数据
- (void)clearReuseData
{
    self.titleLabel.text = @"";
    self.infoLabel.text = @"";
}

#pragma mark - Actions

- (void)addButtonAction:(UIButton *)button
{
    [self.listTableView endEditing:YES];
    
    // MARK: add new cell
    [self.model.valueList addObject:@{
        @"id" : [NSString stringWithFormat:@"%d", arc4random() % 100000000],
        @"value" : @"",
        @"cpnConfig" : @{
            @"prefixDataSource" : self.model.cpnConfig.prefixDataSource?:@[],
            @"suffixDataSource" : self.model.cpnConfig.suffixDataSource?:@[]
        }
    }];
    self.model.valueList = [[self.model.valueList subarrayWithRange:NSMakeRange(0, MIN(self.model.valueList.count, self.model.cpnConfig.maxLimit))] mutableCopy];
    self.addButton.enabled = (self.model.valueList.count < self.model.cpnConfig.maxLimit);
    [self updateMyConstraints];

    [self.listTableView reloadData];
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];

    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
}

#pragma mark - Getters

- (UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _listTableView.layer.cornerRadius = 8.0;
//        _listTableView.layer.masksToBounds = YES;
        _listTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _listTableView.scrollEnabled = NO;
        _listTableView.sectionFooterHeight = 0;
        _listTableView.sectionHeaderHeight = 0;
        _listTableView.estimatedRowHeight = 100;
        _listTableView.rowHeight = UITableViewAutomaticDimension;
        [_listTableView registerClass:[IMSFormMultiTextFieldItemCell class] forCellReuseIdentifier:NSStringFromClass([IMSFormMultiTextFieldItemCell class])];
    }
    return _listTableView;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage bundleImageWithNamed:@"ic_add_comment"] forState:UIControlStateNormal];
        [_addButton setTitle:@"Add More" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        UIEdgeInsets edge = _addButton.imageEdgeInsets;
        edge.left = -6.0;
        _addButton.imageEdgeInsets = edge;
        edge = _addButton.titleEdgeInsets;
        edge.left = 6.0;
        _addButton.titleEdgeInsets = edge;
        _addButton.layer.cornerRadius = 8.0;
//        _addButton.layer.borderWidth = 1.0;
//        _addButton.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        [_addButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _addButton;
}

//- (IMSPopupSingleSelectListView *)prefixSingleSelectListView {
//    if (_prefixSingleSelectListView == nil) {
//        _prefixSingleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
//    }
//    return _prefixSingleSelectListView;
//}
//
//- (IMSPopupSingleSelectListView *)suffixSingleSelectListView {
//    if (_suffixSingleSelectListView == nil) {
//        _suffixSingleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
//    }
//    return _suffixSingleSelectListView;
//}


@end
