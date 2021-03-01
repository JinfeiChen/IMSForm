//
//  IMSFormMultiTextFieldCell.m
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import "IMSFormMultiTextFieldCell.h"
#import <IMSForm/IMSFormManager.h>

#define kFormTBMultiTextFieldItemHeight 40.0

@interface IMSFormMultiTextFieldItemCell : IMSFormTableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) UIButton *deleteBtn; /**< <#property#> */
@property (strong, nonatomic) UITextField *textField;
@property (copy, nonatomic) void (^ deleteBlock)(UIButton *button); /**< <#property#> */
@property (copy, nonatomic) void (^ didEndEditingBlock)(UITextField *textField); /**< <#property#> */

@end

@implementation IMSFormMultiTextFieldItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildView];
        
        __weak __typeof__(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
            __typeof__(self) strongSelf = weakSelf;
            if (note.object == strongSelf.textField) {
                // call back
                if (strongSelf.didEndEditingBlock) {
                    strongSelf.didEndEditingBlock(strongSelf.textField);
                }
            }
        }];
    }
    return self;
}

- (void)buildView
{
    CGFloat spacing = 10.0;
    
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kFormTBMultiTextFieldItemHeight, kFormTBMultiTextFieldItemHeight));
        make.top.bottom.right.mas_equalTo(self.contentView).offset(0);
    }];
    
    [self.contentView addSubview:self.textField];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(spacing);
        make.right.mas_equalTo(self.deleteBtn.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kFormTBMultiTextFieldItemHeight-10);
    }];
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

#pragma mark - Actions

- (void)deleteBtnAction:(UIButton *)button
{
    if (self.deleteBlock) {
        self.deleteBlock(button);
    }
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

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage bundleImageWithNamed:@"search_clean"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end


@interface IMSFormMultiTextFieldCell () <UITableViewDelegate, UITableViewDataSource>

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
    cell.textField.text = [NSString stringWithFormat:@"%@", [modelDict valueForKey:@"value"] ? : @"N/A"];
    cell.textField.placeholder = self.model.placeholder;
    cell.deleteBtn.hidden = !self.model.isEditable;
    cell.contentView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    cell.deleteBlock = ^(UIButton *button) {
        
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
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:[self.model.valueList objectAtIndex:indexPath.row]];
        [mDict setValue:textField.text forKey:@"value"];
        [self.model.valueList replaceObjectAtIndex:indexPath.row withObject:mDict];
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
    
    CGFloat spacingHeight = self.model.cpnStyle.spacing * ((self.model.valueList.count > 0) ? 2 : 1) + 5;
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
    
    // MARK: add new files
    [self.model.valueList addObject:@{
        @"id" : [NSString stringWithFormat:@"%d", arc4random() % 100000000],
        @"value" : @""
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
        _listTableView.layer.cornerRadius = 8.0;
        _listTableView.layer.masksToBounds = YES;
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


@end
