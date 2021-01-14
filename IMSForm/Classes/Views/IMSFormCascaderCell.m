//
//  IMSFormCascaderCell.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/13.
//

#import "IMSFormCascaderCell.h"
#import "IMSTagView.h"
#import "IMSPopupTreeSelectListView.h"

@interface IMSFormCascaderCell ()
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) IMSTagView *tagView;

@property (nonatomic, strong) IMSPopupTreeSelectListView *listView;
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
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
    
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
    
    [UIView animateWithDuration:0.3 animations:^{
        if (model.isSelected) {
            self.arrowButton.transform = CGAffineTransformMakeRotation(M_PI_2);
        } else {
            self.arrowButton.transform = CGAffineTransformIdentity;
        }
    }];
    
    BOOL hasData = model.valueList && model.valueList.count > 0;
    
    self.placeholderLabel.hidden = hasData;
    self.placeholderLabel.text = hasData ? @"" : (self.model.placeholder ? : @"Please Select");
    self.arrowButton.hidden = model.isEditable ? NO : YES;
    self.tagView.deleteImage = model.isEditable ? [UIImage bundleImageWithNamed:@"search_close_tag"] : nil;
    
    [self updateTagViewDataSource];
    
}
#pragma mark - Private Methods
- (void)updateTagViewDataSource
{
    NSArray *valueModelArray = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:self.model.valueList];
    NSMutableArray *titleArrayM = [NSMutableArray array];
    for (IMSPopupMultipleSelectModel *model in valueModelArray) {
        [titleArrayM addObject:model.label?:@"N/A"];
    }
    self.tagView.dataArray = titleArrayM;
}

#pragma mark - RATagViewDelegate
- (void)tagView:(IMSTagView *)tagView didSelectAtIndex:(NSInteger)index
{
    // delete
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.model.valueList];
    [mArr removeObjectAtIndex:index];
    // update model's valueList
    self.model.cpnConfig.selectDataSource = mArr;
    
    // update tagview datasource
    [self updateTagViewDataSource];
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
    
//    // call back
//    if (self.didUpdateFormModelBlock) {
//        self.didUpdateFormModelBlock(self, self.model, nil);
//    }
    
    BOOL hasData = self.model.valueList && self.model.valueList.count > 0;
    self.placeholderLabel.hidden = hasData;
    self.placeholderLabel.text = hasData ? @"" : (self.model.placeholder ? : @"Please Select");
}


- (void)clickAction:(id)sender
{
    if (!self.model) {
        return;
    }
    
    // MARK: Show multiple select list view
           self.listView.dataArray = self.model.cpnConfig.selectDataSource;
           
           [self.listView showView];
           
           @weakify(self);
//           [self.listView setRefreshUI:^{
//               @strongify(self);
//               [self.form.tableView reloadData];
//           }];
           
           [self.listView setDidSelectedBlock:^(IMSPopupMultipleSelectModel * _Nonnull selectedModel, BOOL isAdd, NSString *tipString) {
               @strongify(self);
               NSLog(@"%@, isAdd = %d", [selectedModel yy_modelToJSONObject], isAdd);
               
           }];
    
//    // call back
//    if (self.customDidSelectedBlock) {
//        self.customDidSelectedBlock(self, self.model, nil);
//    }
}


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

- (IMSPopupTreeSelectListView *)listView {
    if (_listView == nil) {
        _listView = [[IMSPopupTreeSelectListView alloc] init];
    }
    return _listView;
}

@end
