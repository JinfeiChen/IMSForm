//
//  IMSFormFileCell.m
//  IMSForm
//
//  Created by cjf on 7/1/2021.
//

#import "IMSFormFileCell.h"

#define kFormTBFileRowHeight 35.0

@interface IMSFormFileSubCell : UITableViewCell

@property (strong, nonatomic) UIButton *deleteBtn; /**< <#property#> */
@property (strong, nonatomic) UIImageView *iconImgView; /**< <#property#> */
@property (strong, nonatomic) UILabel *myTitleLabel; /**< <#property#> */
@property (copy, nonatomic) void (^ deleteBlock)(UIButton *button); /**< <#property#> */

@end

@implementation IMSFormFileSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildView];
    }
    return self;
}

- (void)buildView
{
    CGFloat spacing = 10.0;
    
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kFormTBFileRowHeight, kFormTBFileRowHeight));
        make.top.right.bottom.mas_equalTo(self.contentView).offset(0);
    }];
    
    [self.contentView addSubview:self.iconImgView];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(spacing);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(kFormTBFileRowHeight / 4, kFormTBFileRowHeight / 3));
    }];

    [self.contentView addSubview:self.myTitleLabel];
    [self.myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(spacing);
        make.right.mas_equalTo(self.deleteBtn.mas_left).offset(-spacing);
    }];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    CGFloat imgW = 12;
//    CGFloat imgH = 15;
//    CGFloat padding = (kFormTBFileRowHeight - imgH) / 2;
//    CGRect frame = self.imageView.frame;
//    self.imageView.frame = CGRectMake(CGRectGetMinX(frame), padding, imgW, imgH);
//}

#pragma mark - Actions

- (void)deleteBtnAction:(UIButton *)button
{
    if (self.deleteBlock) {
        self.deleteBlock(button);
    }
}

#pragma mark - Getters

- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.image = [UIImage bundleImageWithNamed:@"file"];
    }
    return _iconImgView;
}

- (UILabel *)myTitleLabel
{
    if (!_myTitleLabel) {
        _myTitleLabel = [[UILabel alloc] init];
        _myTitleLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
        _myTitleLabel.textColor = [UIColor grayColor];
        _myTitleLabel.text = @"filename";
    }
    return _myTitleLabel;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage bundleImageWithNamed:@"search_close_tag"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end

@interface IMSFormFileCell () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *listArray; /**< <#property#> */

@end

@implementation IMSFormFileCell

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
    [self.contentView addSubview:self.bodyView];
    [self.contentView addSubview:self.infoLabel];
    [self.bodyView addSubview:self.addButton];
    [self.bodyView addSubview:self.listTableView];
    
    [self updateUI];
}

- (void)updateUI
{
    self.contentView.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.backgroundHexColor]);

    self.bodyView.backgroundColor = [UIColor clearColor];

    self.titleLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.titleHexColor]);
    self.titleLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.titleFontSize weight:UIFontWeightMedium];

    self.infoLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.infoFontSize weight:UIFontWeightRegular];
    self.infoLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.infoHexColor]);

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
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, kIMSFormDefaultHeight));
        make.top.left.mas_equalTo(self.bodyView).offset(0);
    }];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addButton.mas_bottom).offset(spacing);
        make.left.right.mas_equalTo(self.bodyView).offset(0);
        make.bottom.mas_equalTo(self.bodyView).offset(0).priorityLow(); // 消除控制台中提示约束重载的冲突
    }];

    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
}

- (void)updateMyConstraints
{
    [self.listTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addButton.mas_bottom).offset(self.listArray.count > 0 ? self.model.cpnStyle.spacing : 0);
    }];
}

#pragma mark - Private Methods

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];

    [self updateUI];

    [self setTitle:model.title required:model.isRequired];

    self.infoLabel.text = model.info;

    self.bodyView.userInteractionEnabled = model.isEditable;

    NSError *localError = nil;
    NSData *jsonData = [model.value dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:&localError];
    NSLog(@"%@", jsonObject);
    if (!localError && [jsonObject isKindOfClass:[NSArray class]]) {
        [self.listArray addObjectsFromArray:[jsonObject subarrayWithRange:NSMakeRange(0, MIN(jsonObject.count, model.cpnConfig.maxFilesLimit))]];
    }
    self.addButton.enabled = (self.listArray.count < self.model.cpnConfig.maxFilesLimit);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MIN(self.listArray.count, self.model.cpnConfig.maxFilesLimit);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMSFormFileSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSFormFileSubCell class])];
    NSDictionary *modelDict = self.listArray[indexPath.row];
    cell.myTitleLabel.text = [NSString stringWithFormat:@"%@", [modelDict valueForKey:@"name"]];
    cell.deleteBlock = ^(UIButton *button) {
        // delete
        [self.listArray removeObjectAtIndex:indexPath.row];
        self.model.value = [self.listArray yy_modelToJSONString];
        self.addButton.enabled = (self.listArray.count < self.model.cpnConfig.maxFilesLimit);
        [self updateMyConstraints];
        [self.listTableView reloadData];
        [self.form.tableView beginUpdates];
        [self.form.tableView endUpdates];
        
        // call back
        if (self.didUpdateFormModelBlock) {
            self.didUpdateFormModelBlock(self, self.model, nil);
        }
    };
    return cell;
}

#pragma mark - UIView (UIConstraintBasedLayoutFittingSize)

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    self.listTableView.frame = CGRectMake(0, 0, targetSize.width, 44);
    [self.listTableView layoutIfNeeded];
    
    YYLabel *contentL = [[YYLabel alloc] init];
    //计算标题文本尺寸
    NSMutableAttributedString *titleAttri = [[NSMutableAttributedString alloc] initWithString:self.model.title];
    CGSize maxSize = CGSizeMake(targetSize.width - self.model.cpnStyle.contentInset.left - self.model.cpnStyle.contentInset.right, MAXFLOAT);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:titleAttri];
    contentL.textLayout = layout;
    CGFloat titleHeight = layout.textBoundingSize.height;
    
    NSMutableAttributedString *infoAttri = [[NSMutableAttributedString alloc] initWithString:self.model.info];
    maxSize = CGSizeMake(targetSize.width - self.model.cpnStyle.contentInset.left - self.model.cpnStyle.contentInset.right, MAXFLOAT);
    layout = [YYTextLayout layoutWithContainerSize:maxSize text:infoAttri];
    contentL.textLayout = layout;
    CGFloat infoHeight = layout.textBoundingSize.height;
    
    CGFloat spacingHeight = self.model.cpnStyle.spacing * ((self.listArray.count > 0) ? 2 : 1) + 5;
    CGFloat buttonHeight = kIMSFormDefaultHeight;
    NSInteger count = MIN(self.listArray.count, self.model.cpnConfig.maxFilesLimit);
    CGFloat contentViewHeight = kFormTBFileRowHeight * count + self.model.cpnStyle.contentInset.top + self.model.cpnStyle.contentInset.bottom + titleHeight + self.listTableView.contentInset.top + self.listTableView.contentInset.bottom + spacingHeight + buttonHeight + infoHeight;
    return CGSizeMake(targetSize.width, contentViewHeight);
}

#pragma mark - Actions

- (void)addButtonAction:(UIButton *)button
{
    if (self.listArray.count >= self.model.cpnConfig.maxFilesLimit) {
        return;
    }
     
    if (self.customDidSelectedBlock) {
        self.customDidSelectedBlock(self, self.model, nil);
    }
}

#pragma mark - Getters

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

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
        [_listTableView registerClass:[IMSFormFileSubCell class] forCellReuseIdentifier:NSStringFromClass([IMSFormFileSubCell class])];
    }
    return _listTableView;
}

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage bundleImageWithNamed:@"upload"] forState:UIControlStateNormal];
        [_addButton setTitle:@"Click to upload" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        UIEdgeInsets edge = _addButton.titleEdgeInsets;
        edge.left = 12.0;
        _addButton.titleEdgeInsets = edge;
        _addButton.layer.cornerRadius = 8.0;
//        _addButton.layer.borderWidth = 1.0;
//        _addButton.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        [_addButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _addButton;
}

@end
