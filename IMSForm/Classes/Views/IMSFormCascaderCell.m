//
//  IMSFormCascaderCell.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/13.
//

#import "IMSFormCascaderCell.h"
#import "IMSTagView.h"
#import "IMSPopupTreeSelectListView.h"
#import "IMSFormCascaderModel.h"

@interface IMSFormCascaderCell ()<IMSTagViewDelegate>
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) IMSTagView *tagView;
@end

@implementation IMSFormCascaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
        [self.bodyView addGestureRecognizer:tap];
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
    [self.bodyView addSubview:self.tagView];
    [self.bodyView addSubview:self.placeholderLabel];
    [self.bodyView addSubview:self.arrowButton];
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
    }];
    
    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.bodyView);
        make.right.equalTo(self.arrowButton.mas_left);
    }];
    
    [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bodyView).offset(10);
        make.top.bottom.equalTo(self.bodyView);
        make.right.equalTo(self.arrowButton.mas_left).offset(-10);
    }];
    
    [self.arrowButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.right.equalTo(self.bodyView);
        make.centerY.equalTo(self.bodyView);
        make.width.equalTo(@40);
    }];

    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.bodyView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
    }];
    
//    [self.form.tableView beginUpdates];
//    [self.form.tableView endUpdates];
    
}

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self setTitle:model.title required:model.isRequired];
    
    self.infoLabel.text = model.info;
    
    self.bodyView.userInteractionEnabled = model.isEditable;
    
    self.bodyView.userInteractionEnabled = model.isEditable;
    self.bodyView.backgroundColor = model.isEditable ? [UIColor whiteColor] : [UIColor colorWithWhite:0.95 alpha:1.0];
    
    [self updateArrowButton];
    
    self.arrowButton.hidden = model.isEditable ? NO : YES;
    self.tagView.deleteImage = model.isEditable ? [UIImage bundleImageWithNamed:@"search_close_tag"] : nil;
    
    [self updateTagViewDataSource];
    
}
#pragma mark - Private Methods
- (void)updateTagViewDataSource
{
    NSMutableArray *titleArrayM = [NSMutableArray array];
    
    for (IMSFormSelect *model in self.model.valueList) {
        [titleArrayM addObject:model.value?:@"N/A"];
    }
    self.tagView.dataArray = titleArrayM;
    
    BOOL hasData = self.model.valueList && self.model.valueList.count > 0;
    
    self.placeholderLabel.hidden = hasData;
     
    self.placeholderLabel.text = hasData ? @"" : (self.model.placeholder ? : @"Please Select");
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
}

#pragma mark - RATagViewDelegate
- (void)tagView:(IMSTagView *)tagView didSelectAtIndex:(NSInteger)index
{
    // delete
    [self.model.valueList removeObjectAtIndex:index];
    
    // update tagview datasource
    [self updateTagViewDataSource];
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
    
    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
    BOOL hasData = self.model.valueList && self.model.valueList.count > 0;
    self.placeholderLabel.hidden = hasData;
    self.placeholderLabel.text = hasData ? @"" : (self.model.placeholder ? : @"Please Select");
    
    for (int i = 0; i < self.model.valueList.count; ++i) {
        IMSFormSelect *model = self.model.valueList[i];
        NSLog(@"%@",model.value);
    }
    
    
}


- (void)clickAction:(id)sender
{
    if (!self.model)  return;
    
    // MARK: Show multiple select list view
    IMSFormCascaderModel *cascaderModel = (IMSFormCascaderModel *)self.model;
    IMSPopupTreeSelectListView *listView = [[IMSPopupTreeSelectListView alloc]init];
    [self dealStatus:cascaderModel.cpnConfig.selectDataSource andHaveDataSource:cascaderModel.valueList];// 重置按钮状态
    listView.dataArray = cascaderModel.cpnConfig.selectDataSource;
    listView.maxCount = cascaderModel.cpnConfig.maxCount;
    listView.didSelectedCount = cascaderModel.cpnConfig.didSelectedCount;
    
    @weakify(self);
    [listView setDidFinishedShowAndHideBlock:^(BOOL isShow) {
        @strongify(self);
        self.model.selected = isShow;
        [self updateArrowButton];
    }];
    
    [listView showView];
    
    [listView setDidSelectedBlock:^(IMSPopupMultipleSelectModel * _Nonnull selectedModel, BOOL isAdd, NSString *tipString) {
        @strongify(self);
//        NSLog(@"%@, isAdd = %d", [selectedModel yy_modelToJSONObject], isAdd);
        if (isAdd) {
            cascaderModel.cpnConfig.didSelectedCount ++ ;
            [self.model.valueList addObject:selectedModel];
        }else {
            cascaderModel.cpnConfig.didSelectedCount -- ;
            [self.model.valueList removeObject:selectedModel];
        }
        [self updateTagViewDataSource];
    }];
//    // call back
//    if (self.customDidSelectedBlock) {
//        self.customDidSelectedBlock(self, self.model, nil);
//    }
}

- (void)dealStatus:(NSArray *)allDataSource andHaveDataSource:(NSArray *)haveDataSource {
    
    for (int i = 0; i < allDataSource.count; ++i) {
        IMSFormSelect *dataModel = allDataSource[i];
        for (IMSFormSelect *valueListModel in haveDataSource) {
            if ([dataModel.value isEqualToString:valueListModel.value]) {
                dataModel.selected = YES;
                break;
            }else {
                dataModel.selected = NO;
            }
        }
        if (i < allDataSource.count - 1) {
            [self dealStatus:dataModel.child andHaveDataSource:haveDataSource];
        }
    }
}

- (void)updateArrowButton
{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.model.isSelected) {
            self.arrowButton.transform = CGAffineTransformMakeRotation(M_PI_2);
        } else {
            self.arrowButton.transform = CGAffineTransformIdentity;
        }
    }];
}


#pragma mark - lazy load
- (UILabel *)placeholderLabel {
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = IMS_HEXCOLOR(0xC4C7D1);
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
    }
    return _placeholderLabel;
}

- (UIButton *)arrowButton {
    if (_arrowButton == nil) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowButton setImage:[UIImage bundleImageWithNamed:@"search_next"] forState:UIControlStateNormal];
        _arrowButton.userInteractionEnabled = NO;
    }
    return _arrowButton;
}

- (IMSTagView *)tagView {
    if (_tagView == nil) {
        _tagView = [[IMSTagView alloc] init];
        _tagView.minimumLineSpacing = 5;
        _tagView.tagsMinPadding = 10;
        _tagView.minimumInteritemSpacing = 5;
        _tagView.tagItemfontSize = [UIFont systemFontOfSize:12];
        _tagView.tagItemHeight = 25.0;
        _tagView.contentInset = UIEdgeInsetsMake(7.5, 10, 7.5, 0);
        _tagView.tagSuperviewWidth = [UIScreen mainScreen].bounds.size.width - 60;
        _tagView.contentPadding = 5.0;
        _tagView.tagSuperviewMinHeight = 40.0;
        _tagView.deleteImage = [UIImage bundleImageWithNamed:@"search_close_tag"];
        _tagView.delegate = self;
    }
    return _tagView;
}

@end
