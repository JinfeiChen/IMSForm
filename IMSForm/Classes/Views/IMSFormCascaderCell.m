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
// only for single select
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) IMSTagView *tagView;
@property (nonatomic, strong) NSMutableArray *valueListM;
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
    [self.bodyView addSubview:self.contentLabel];
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
    self.bodyView.userInteractionEnabled = self.model.isEditable;
    self.bodyView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    self.tagView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
    
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
    
    [self.arrowButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.right.equalTo(self.bodyView);
        make.centerY.equalTo(self.bodyView);
        make.width.equalTo(self.model.isEditable ? @40 : @0);
    }];
    
    self.tagView.tagSuperviewWidth = [UIScreen mainScreen].bounds.size.width - self.model.cpnStyle.contentInset.left - self.model.cpnStyle.contentInset.right - (self.model.isEditable ? 40 : 0);
    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.bodyView);
        make.right.equalTo(self.arrowButton.mas_left);
    }];
    
    [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bodyView).offset(10);
        make.top.equalTo(self.bodyView);
        make.height.equalTo(@40);
        make.right.equalTo(self.arrowButton.mas_left).offset(-10);
        make.bottom.equalTo(self.bodyView).priority(500);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.placeholderLabel);
    }];
    
//    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.bodyView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
    }];
    
}

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self setTitle:model.title required:model.isRequired];
    
    self.infoLabel.text = model.info;
    
    [self updateArrowButton];
    
    self.arrowButton.hidden = model.isEditable ? NO : YES;
    
    IMSFormCascaderModel *cascaderModel = (IMSFormCascaderModel *)self.model;
    
    self.valueListM = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:self.model.valueList].mutableCopy;
    
    if (cascaderModel.cpnConfig.isMultiple) {
        self.tagView.hidden = NO;
        self.contentLabel.hidden = YES;
        self.tagView.deleteImage = model.isEditable ? [UIImage bundleImageWithNamed:@"search_close_tag"] : nil;
        [self updateTagViewDataSource];
    }else {
        self.tagView.hidden = YES;
        self.contentLabel.hidden = NO;
        [self updateContentLable];
    }
}
#pragma mark - Private Methods
- (void)updateTagViewDataSource {
    
    NSMutableArray *titleArrayM = [NSMutableArray array];
    for (IMSFormSelect *model in self.valueListM) {
        [titleArrayM addObject:model.label ?: (model.value ?: @"N/A")];
    }
    
    self.tagView.dataArray = titleArrayM;
    
    BOOL hasData = self.valueListM && self.valueListM.count > 0;
    
    self.placeholderLabel.hidden = hasData;
     
    self.placeholderLabel.text = hasData ? @"" : (self.model.placeholder ? : @"Please Select");
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
}

- (void)updateContentLable {
    
    IMSFormSelect *formSelect = self.valueListM.firstObject;
    
    BOOL hasData = self.valueListM && self.valueListM.count > 0;
    
    self.placeholderLabel.hidden = hasData;
     
    self.placeholderLabel.text = hasData ? @"" : (self.model.placeholder ? : @"Please Select");
    
    self.contentLabel.text = formSelect.label ?: (formSelect.value ?: @"");
}

#pragma mark - RATagViewDelegate
- (void)tagView:(IMSTagView *)tagView didSelectAtIndex:(NSInteger)index
{
    // delete
    [self.valueListM removeObjectAtIndex:index];
    self.model.valueList = [self.valueListM yy_modelToJSONObject];
    
    // update tagview datasource
    [self updateTagViewDataSource];
    
    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
    
}

- (void)clickAction:(id)sender
{
    if (!self.model)  return;
    
    // MARK: Show multiple select list view
    IMSFormCascaderModel *cascaderModel = (IMSFormCascaderModel *)self.model;
    IMSPopupTreeSelectListView *listView = [[IMSPopupTreeSelectListView alloc]init];
    [self dealStatus:cascaderModel.cpnConfig.dataSource andHaveDataSource:self.valueListM];// 重置按钮状态
    listView.isMultiple = cascaderModel.cpnConfig.isMultiple;
    listView.dataArray = cascaderModel.cpnConfig.dataSource;
    listView.maxCount = cascaderModel.cpnConfig.maxCount;
    listView.seleceDataSource = cascaderModel.valueList;
    
    @weakify(self);
    [listView setDidFinishedShowAndHideBlock:^(BOOL isShow) {
        @strongify(self);
        self.model.selected = isShow;
        [self updateArrowButton];
    }];
    
    [listView showView];
    
    [listView setDidSelectedBlock:^(NSMutableArray *selectDataSource, IMSFormSelect * _Nonnull selectedModel, NSString *tipString) {
        @strongify(self);
        
        self.model.valueList = selectDataSource;
        
        self.valueListM = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:self.model.valueList].mutableCopy;

        cascaderModel.cpnConfig.isMultiple ? [self updateTagViewDataSource] : [self updateContentLable];
        
        // call back
        if (self.didUpdateFormModelBlock) {
            self.didUpdateFormModelBlock(self, self.model, nil);
        }
    }];
}

- (void)dealStatus:(NSArray *)allDataSource andHaveDataSource:(NSArray *)haveDataSource {
    
    for (int i = 0; i < allDataSource.count; ++i) {
        IMSFormSelect *dataModel = allDataSource[i];
        dataModel.selected = NO;
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
        _placeholderLabel.font = [UIFont systemFontOfSize:12];
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
        _tagView.contentPadding = 5.0;
        _tagView.tagSuperviewMinHeight = 40.0;
        _tagView.deleteImage = [UIImage bundleImageWithNamed:@"search_close_tag"];
        _tagView.delegate = self;
    }
    return _tagView;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = IMS_HEXCOLOR(0x565465);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor clearColor];
    }
    return _contentLabel;
}

- (NSMutableArray *)valueListM {
    if (_valueListM == nil) {
        _valueListM = [[NSMutableArray alloc] init];
    }
    return _valueListM;
}

@end
