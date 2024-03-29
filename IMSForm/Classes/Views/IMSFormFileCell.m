//
//  IMSFormFileCell.m
//  IMSForm
//
//  Created by cjf on 7/1/2021.
//

#import "IMSFormFileCell.h"

#import <IMSForm/IMSFormManager.h>
#import <IMSForm/IMSFormNetworking.h>
#import <IMSForm/IMSFormManager+HUD.h>

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
    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kFormTBFileRowHeight, kFormTBFileRowHeight));
        make.top.right.bottom.mas_equalTo(self.contentView).offset(0);
    }];
    
    [self.contentView addSubview:self.iconImgView];
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(spacing);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(kFormTBFileRowHeight / 4, kFormTBFileRowHeight / 3));
    }];

    [self.contentView addSubview:self.myTitleLabel];
    [self.myTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(spacing);
        make.right.mas_equalTo(self.deleteBtn.mas_left).offset(0);
    }];
}

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
        _iconImgView.image = [UIImage bundleImageWithNamed:@"ims-icon-file"];
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

@property (strong, nonatomic) IMSFormNetworking *sessionManager; /**< <#property#> */

@end

@implementation IMSFormFileCell

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
    [self.contentView addSubview:self.bodyView];
    [self.contentView addSubview:self.infoLabel];
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
        make.top.left.mas_equalTo(self.bodyView).offset(0);
    }];
    [self.listTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addButton.mas_bottom).offset(spacing).priorityLow();
        make.left.right.mas_equalTo(self.bodyView).offset(0);
        make.bottom.mas_equalTo(self.bodyView).offset(0).priorityLow(); // 消除控制台中提示约束重载的冲突
    }];
}

- (void)updateMyConstraints
{
    [self.listTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addButton.mas_bottom).offset(self.model.listArray.count > 0 ? self.model.cpnStyle.spacing : 0);
    }];
}

#pragma mark - Private Methods

// 清除重用数据
- (void)clearReuseData
{
    self.titleLabel.text = @"";
    self.infoLabel.text = @"";
}

- (void)uploadFile:(NSDictionary *)fileData
{
    // MARK: 获取上传结果数据
    SEL selector = NSSelectorFromString(self.model.cpnConfig.fileUploadSelectorString);
    if (!selector) {
        [self.form showWarning:@"Undeclared file upload method"];
        return;
    }
    if (self.form.dataDelegate && [self.form.dataDelegate respondsToSelector:selector]) {
        @weakify(self);
        void(^uploadBlock)(NSArray <NSDictionary *> *dataArray) = ^(NSArray <NSDictionary *> *dataArray) {
            @strongify(self);

            NSLog(@"upload result: %@", dataArray);
            if (!dataArray || ![dataArray isKindOfClass:[NSArray class]]) {
                return;
            }

            // MARK: add new files
            for (NSDictionary *dict in dataArray) {
                [self.model.listArray addObject:dict];
            }
            self.model.listArray = [[self.model.listArray subarrayWithRange:NSMakeRange(0, MIN(self.model.listArray.count, self.model.cpnConfig.maxFilesLimit))] mutableCopy];
            self.addButton.enabled = (self.model.listArray.count < self.model.cpnConfig.maxFilesLimit);
            [self updateMyConstraints];

            [self.listTableView reloadData];
            [self.form.tableView beginUpdates];
            [self.form.tableView endUpdates];

            // update model valueList
            self.model.valueList = [self.model.listArray copy];

            // call back
            if (self.didUpdateFormModelBlock) {
                self.didUpdateFormModelBlock(self, self.model, nil);
            }

        };
        [self.form.dataDelegate performSelector:selector withObject:fileData withObject:uploadBlock];

    } else {
        [self.form showWarning:@"Please implement the data file upload method"];
    }
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self clearReuseData];
    [self setTitle:model.title required:model.isRequired];

    self.infoLabel.text = model.info;
    
    // update default value
    self.model.listArray = [NSMutableArray array];
    NSArray *valueList = self.model.valueList;
    if (valueList && [valueList isKindOfClass:[NSArray class]]) {
        [self.model.listArray addObjectsFromArray:[valueList subarrayWithRange:NSMakeRange(0, MIN(valueList.count, self.model.cpnConfig.maxFilesLimit))]];
    }
    
    if (self.model.isEditable) {
        self.addButton.enabled = (self.model.listArray.count < self.model.cpnConfig.maxFilesLimit);
    } else {
        self.addButton.enabled = NO;
    }
    
    [self.listTableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MIN(self.model.listArray.count, self.model.cpnConfig.maxFilesLimit);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMSFormFileSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSFormFileSubCell class])];
    NSDictionary *modelDict = self.model.listArray[indexPath.row];
    cell.myTitleLabel.text = [NSString stringWithFormat:@"%@", [modelDict valueForKey:@"name"] ? : @"N/A"];
    cell.deleteBtn.hidden = !self.model.isEditable;
    cell.contentView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    cell.deleteBlock = ^(UIButton *button) {
        
        // MARK: delete file
        [self.model.listArray removeObjectAtIndex:indexPath.row];
        self.addButton.enabled = (self.model.listArray.count < self.model.cpnConfig.maxFilesLimit);
        [self updateMyConstraints];
        
        [self.listTableView reloadData];
        [self.form.tableView beginUpdates];
        [self.form.tableView endUpdates];
        
        // update model valueList
        self.model.valueList = [self.model.listArray copy];
        
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
    
    CGFloat spacingHeight = self.model.cpnStyle.spacing * ((self.model.listArray.count > 0) ? 2 : 1) + 10;
    CGFloat buttonHeight = kIMSFormDefaultHeight;
    NSInteger count = MIN(self.model.listArray.count, self.model.cpnConfig.maxFilesLimit);
    CGFloat contentViewHeight = kFormTBFileRowHeight * count + self.model.cpnStyle.contentInset.top + self.model.cpnStyle.contentInset.bottom + titleHeight + self.listTableView.contentInset.top + self.listTableView.contentInset.bottom + spacingHeight + buttonHeight + infoHeight;
    return CGSizeMake(targetSize.width, contentViewHeight);
}

#pragma mark - Actions

- (void)addButtonAction:(UIButton *)button
{
    if (self.model.listArray.count >= self.model.cpnConfig.maxFilesLimit) {
        return;
    }
    
    if (!self.model.isEnable || !self.model.isEditable) {
        return;
    }
    
    [self.filePicker presentDocumentPicker];
    @weakify(self);
    self.filePicker.documentPickerFinishedBlock = ^(NSData * _Nonnull fileData, NSURL * _Nonnull fileURL, NSString * _Nonnull fileName, NSError * _Nullable error) {
        @strongify(self);
//        NSLog(@"fileData: %@, fileName: %@, fileURL: %@, error: %@", fileData, fileName, fileURL, error);
        
        NSMutableDictionary *obj = [NSMutableDictionary dictionary];
        if (fileData) {
            [obj setObject:fileData forKey:@"fileData"];
        }
        if (fileURL) {
            [obj setObject:fileURL forKey:@"fileURL"];
        }
        if (fileName) {
            [obj setObject:fileName forKey:@"fileName"];
        }
        if (error) {
            [obj setObject:error forKey:@"error"];
        }
        
        // 上传方法外置
        [self uploadFile:obj];
    };
    
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

- (IMSFilePicker *)filePicker
{
    if (!_filePicker) {
        _filePicker = [[IMSFilePicker alloc] init];
    }
    return _filePicker;
}

- (IMSFormNetworking *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [[IMSFormNetworking alloc] init];
    }
    return _sessionManager;
}

@end
