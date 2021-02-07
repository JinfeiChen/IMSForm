//
//  IMSFormInputSearchCell.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormInputSearchCell.h"
#import <IMSForm/IMSFormManager.h>
#import <IMSForm/IMSPopupSingleSelectListView.h>

@interface IMSFormInputSearchCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *searchView;
@property (strong, nonatomic) IMSPopupSingleSelectListView *singleSelectListView; /**< <#property#> */
@property (strong, nonatomic) UIButton *searchButton; /**< <#property#> */

@end

@implementation IMSFormInputSearchCell

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
    
    self.bodyView.userInteractionEnabled = self.model.isEditable;
    self.bodyView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    self.textField.backgroundColor = self.bodyView.backgroundColor;
    self.searchButton.enabled = self.model.isEditable;
    
    self.searchButton.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
    
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
            make.edges.equalTo(self.bodyView).with.insets(UIEdgeInsetsMake(0, 10, 0, 0));
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
        }];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bodyView).with.insets(UIEdgeInsetsMake(0, 10, 0, 0));
            make.height.mas_equalTo(kIMSFormDefaultHeight);
        }];
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];
    }
    
//    [self.form.tableView beginUpdates];
//    [self.form.tableView endUpdates];
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
    
    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }
    
    return newLength <= self.model.cpnConfig.lengthLimit || returnKey;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {

    // text type limit, blur 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Blur]) {
        [self validate];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self searchButtonAction:self.searchButton];
    
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

#pragma mark - Private Methods

// 清除重用数据
- (void)clearReuseData
{
    self.titleLabel.text = @"";
    self.infoLabel.text = @"";
    self.textField.text = @"";
    self.textField.placeholder = @"Please enter";
}

- (IMSPopupSingleSelectListViewCellType)cellTypeWithSelectItemType:(NSString *)selectItemType
{
    if ([selectItemType isEqualToString:IMSFormSelectItemType_Contact]) {
        return IMSPopupSingleSelectListViewCellType_Contact;
    }
    else if ([selectItemType isEqualToString:IMSFormSelectItemType_Custom]) {
        return IMSPopupSingleSelectListViewCellType_Custom;
    }
    else {
        return IMSPopupSingleSelectListViewCellType_Default;
    }
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self clearReuseData];
    [self setTitle:model.title required:model.isRequired];
    
    // default value
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected = YES"];
    NSArray *resultArray = [self.model.cpnConfig.dataSource filteredArrayUsingPredicate:predicate];
    if (resultArray && resultArray.count > 0) {
        self.model.valueList = [NSMutableArray arrayWithObjects:resultArray.firstObject, nil];
        IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:resultArray.firstObject];
        self.model.value = selectedModel.label ? : (selectedModel.value ? : @"N/A");
    }
    
    self.textField.text = [self.model.value substringWithRange:NSMakeRange(0, MIN(self.model.value.length, self.model.cpnConfig.lengthLimit))];
    
    self.textField.placeholder = model.placeholder ? : @"Please enter";
    
    self.infoLabel.text = model.info;
}

#pragma mark - Actions

- (void)searchButtonAction:(UIButton *)sender
{
    [self.textField endEditing:YES];
    
    if (self.textField.text.length <= 0) {
        NSLog(@"please input some text first");
        [IMSDropHUD showAlertWithType:IMSFormMessageType_Warning message:@"Please input some text first"];
        return;
    }
    
    self.model.value = self.textField.text;
    
    if (self.form) {
        
        // MARK: 判断是否已自定义selectListView，并获取
        if ([self.model.cpnConfig.selectItemType isEqualToString:IMSFormSelectItemType_Custom]) {
            
            SEL listViewSelector = NSSelectorFromString(@"customInputSearchSelectListView");
            if (self.form.uiDelegate && [self.form.uiDelegate respondsToSelector:listViewSelector]) {
                IMSPopupSingleSelectListView *customListView = [self.form.uiDelegate performSelector:listViewSelector];
                if (customListView && [customListView isKindOfClass:[IMSPopupSingleSelectListView class]]) {
                    self.singleSelectListView = customListView;
                    self.singleSelectListView.cellType = IMSPopupSingleSelectListViewCellType_Custom;
                }
            } else {
                self.singleSelectListView.cellType = [self cellTypeWithSelectItemType:IMSFormSelectItemType_Default];
            }
            
        } else {
            self.singleSelectListView.cellType = [self cellTypeWithSelectItemType:self.model.cpnConfig.selectItemType];
        }
        
        
        // MARK: 获取搜索结果数据
        SEL searchSelector = NSSelectorFromString(self.model.cpnConfig.searchSelectorString);
        if (!searchSelector) {
            [IMSDropHUD showAlertWithType:IMSFormMessageType_Warning message:@"Undeclared search method"];
            return;
        }
        if (self.form.dataDelegate && [self.form.dataDelegate respondsToSelector:searchSelector]) {
            @weakify(self);
            void(^searchCompletedBlock)(NSArray *dataArray) = ^(NSArray *dataArray) {
                @strongify(self);
                
                NSLog(@"search result: %@", dataArray);
                // MARK: 注意 - custom的selectListView，为适应不同的数据模型拓展，dataArray需要在外面转换 [IMSFormSelect, IMSChildFormSelect, ...] 才能回传，否则无法显示
                [self.singleSelectListView setDataArray:dataArray type:self.singleSelectListView.cellType];
                
                [self.singleSelectListView setDidSelectedBlock:^(NSArray * _Nonnull dataArray, IMSFormSelect * _Nonnull selectedModel) {
                    @strongify(self);
                    // update value
                    if ([self.model.cpnConfig.selectItemType isEqualToString:IMSFormSelectItemType_Contact]) {
                        IMSPopupSingleSelectContactModel *newSelectedModel = (IMSPopupSingleSelectContactModel *)selectedModel;
                        self.textField.text = newSelectedModel.name ? : (newSelectedModel.label ? : (newSelectedModel.value ? : @"N/A"));
                        // update model valueList
                        self.model.valueList = selectedModel.isSelected ? [NSMutableArray arrayWithArray:@[[selectedModel yy_modelToJSONObject]]] : [NSMutableArray array];
                    }
                    else if ([self.model.cpnConfig.selectItemType isEqualToString:IMSFormSelectItemType_Custom]) {
                        if (selectedModel && [selectedModel isKindOfClass:[NSDictionary class]]) {
                            IMSFormSelect *newSelectedModel = [IMSFormSelect yy_modelWithDictionary:selectedModel];
                            self.textField.text = newSelectedModel.label ? : (newSelectedModel.value ? : @"N/A");
                        }
                        // update model valueList
                        self.model.valueList = selectedModel.isSelected ? [NSMutableArray arrayWithArray:@[selectedModel]] : [NSMutableArray array];
                    }
                    else {
                        self.textField.text = selectedModel.label ? : (selectedModel.value ? : @"N/A");
                        // update model valueList
                        self.model.valueList = selectedModel.isSelected ? [NSMutableArray arrayWithArray:@[[selectedModel yy_modelToJSONObject]]] : [NSMutableArray array];
                    }
                    
                    
                    // call back
                    if (self.didUpdateFormModelBlock) {
                        self.didUpdateFormModelBlock(self, self.model, nil);
                    }
                    
                }];
                
                self.singleSelectListView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
                
                [self.singleSelectListView showView];
                
            };
            [self.form.dataDelegate performSelector:searchSelector withObject:self.textField.text withObject:searchCompletedBlock];
            
        } else {
            [IMSDropHUD showAlertWithType:IMSFormMessageType_Warning message:@"Please implement the data search method"];
        }
        
    }
}

#pragma mark - Getters

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"Please enter";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:12];
        _textField.returnKeyType = UIReturnKeySearch;
        
//        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
//        leftView.backgroundColor = [UIColor clearColor];
//        _textField.leftView = leftView;
//        _textField.leftViewMode = UITextFieldViewModeAlways;

        [self.searchView addSubview:self.searchButton];
        _textField.rightView = self.searchView;
        _textField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (UIView *)searchView {
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        _searchView.backgroundColor = [UIColor colorWithRed:255/255.0 green:194/255.0 blue:76/255.0 alpha:1.0];
    }
    return _searchView;
}

- (UIButton *)searchButton
{
    if (!_searchButton) {
        UIButton *rightButton = [[UIButton alloc]initWithFrame:self.searchView.bounds];
        [rightButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage bundleImageWithNamed:@"search"] forState:UIControlStateNormal];
        _searchButton = rightButton;
    }
    return _searchButton;
}

- (IMSPopupSingleSelectListView *)singleSelectListView {
    if (!_singleSelectListView) {
        _singleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
    }
    return _singleSelectListView;
}

@end
