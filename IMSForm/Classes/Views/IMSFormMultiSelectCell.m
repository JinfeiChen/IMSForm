//
//  IMSFormMultiSelectCell.m
//  IMSForm
//
//  Created by cjf on 1/2/2021.
//

#import "IMSFormMultiSelectCell.h"

#import <IMSForm/IMSFormManager.h>
#import <IMSForm/IMSTagView.h>
#import <IMSForm/IMSPopupMultipleSelectListView.h>

@interface IMSFormMultiSelectCell () <IMSTagViewDelegate>

@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UILabel *placeholderLabel;

// only for multiple select
@property (nonatomic, strong) IMSTagView *tagView;

@property (strong, nonatomic) NSArray <IMSFormSelect *> *valueModelArray; /**< <#property#> */

@property (strong, nonatomic) IMSPopupMultipleSelectListView *multipleSelectListView; /**< <#property#> */

@end

@implementation IMSFormMultiSelectCell

@synthesize model = _model;

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
    [self.bodyView addSubview:self.arrowButton];
    [self.bodyView addSubview:self.placeholderLabel];
    
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
    
    self.arrowButton.hidden = self.model.isEditable ? NO : YES;
    self.tagView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
    
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
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];
    }
    
    [self.arrowButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.right.equalTo(self.bodyView);
        make.centerY.equalTo(self.bodyView);
        make.width.equalTo(self.model.isEditable ? @40 : @0);
    }];
    
    if (self.model) {
        
        [self.tagView setHidden:NO];
        if (![self.bodyView.subviews containsObject:self.tagView]) {
            [self.bodyView addSubview:self.tagView];
        }
        [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.bodyView);
            make.right.equalTo(self.arrowButton.mas_left);
        }];
        
        [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bodyView).offset(10);
            make.top.equalTo(self.bodyView);
            make.height.mas_equalTo(kIMSFormDefaultHeight);
            make.right.equalTo(self.arrowButton.mas_left).offset(-10);
        }];
        
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
    
    // default value
    NSArray *allArray = [self findChildItemsWithCPNConfigDataSource:self.model.cpnConfig.dataSource];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.selected = YES"];
    NSArray *resultArray = [allArray filteredArrayUsingPredicate:predicate];
    if (resultArray && resultArray.count > 0) {
        self.model.valueList = [NSMutableArray arrayWithArray:resultArray];
    }
    self.valueModelArray = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:self.model.valueList];
    
    [self updateTagViewDataSource];
    
    [self updatePlaceholder];
    [self updateArrowButtonAnimation];
}

- (NSArray *)findChildItemsWithCPNConfigDataSource:(NSArray *)dataSource
{
    NSMutableArray *all = [NSMutableArray array];
    for (NSDictionary *dict in dataSource) {
        NSArray *child = [dict valueForKey:@"child"];
        if (child && [child isKindOfClass:[NSArray class]] && child.count > 0) {
            [all addObjectsFromArray:[self findChildItemsWithCPNConfigDataSource:child]];
        } else {
            [all addObject:dict];
        }
    }
    return all;
}

#pragma mark - Private Methods

// 清除重用数据
- (void)clearReuseData
{
    self.titleLabel.text = @"";
    self.infoLabel.text = @"";
    self.valueModelArray = @[];
    self.tagView.dataArray = @[];
    _multipleSelectListView = nil;
}

- (void)updatePlaceholder
{
    self.placeholderLabel.hidden = (self.model.valueList && self.model.valueList.count > 0) ? YES : NO;
    self.placeholderLabel.text = (self.model.valueList && self.model.valueList.count > 0) ? @"" : (self.model.placeholder ? : @"Please Select");
    
    if (self.valueModelArray.count == 0) {
        self.tagView.dataArray = @[];
    }
}

- (void)updateArrowButtonAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.model.isSelected) {
            self.arrowButton.transform = CGAffineTransformMakeRotation(M_PI_2);
        } else {
            self.arrowButton.transform = CGAffineTransformIdentity;
        }
    }];
}

- (void)updateTagViewDataSource
{
    self.tagView.deleteImage = self.model.isEditable ? [UIImage bundleImageWithNamed:@"search_close_tag"] : nil;
    
    NSMutableArray *titleArrayM = [NSMutableArray array];
    for (IMSFormSelect *model in self.valueModelArray) {
        [titleArrayM addObject:model.value?:@"N/A"];
    }
    self.tagView.dataArray = titleArrayM;
}

#pragma mark - RATagViewDelegate

- (void)tagView:(IMSTagView *)tagView didSelectAtIndex:(NSInteger)index
{
    // delete
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.model.valueList];
    [mArr removeObjectAtIndex:index];
    // update valueModelArray
    self.valueModelArray = [NSArray yy_modelArrayWithClass:[IMSPopupMultipleSelectModel class] json:mArr];
    // update model's valueList
    self.model.valueList = mArr;
    // update tagview datasource
    [self updateTagViewDataSource];
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
    
    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
    [self updatePlaceholder];
}

#pragma mark - Actions

- (void)clickAction:(id)sender
{
    if (!self.model) {
        return;
    }

    // MARK: Show multiple select list view
    IMSPopupMultipleSelectListViewCellType type = [IMSFormTypeManager selectItemTypeWithType:self.model.cpnConfig.selectItemType multiple:YES];
    if (type == IMSPopupMultipleSelectListViewCellType_Custom) {
        if (!_multipleSelectListView) {
            if (self.form.uiDelegate && [self.form.uiDelegate respondsToSelector:NSSelectorFromString(@"customMultipleSelectListViewWithFormModel:")]) {
                _multipleSelectListView = [self.form.uiDelegate customMultipleSelectListViewWithFormModel:self.model];
                [self.multipleSelectListView setDataArray:self.model.cpnConfig.dataSource type:type selectedDataArray:self.model.valueList];
            }
        }
        if (!self.form || !_multipleSelectListView) {
            [self.multipleSelectListView setDataArray:self.model.cpnConfig.dataSource type:IMSPopupMultipleSelectListViewCellType_Default selectedDataArray:self.model.valueList];
        }
    } else {
        [self.multipleSelectListView setDataArray:self.model.cpnConfig.dataSource type:type selectedDataArray:self.model.valueList];
    }
    
    @weakify(self);
    [self.multipleSelectListView setDidSelectedBlock:^(NSArray * _Nonnull selectedDataArray, IMSFormSelect * _Nonnull selectedModel, BOOL isAdd, NSString * _Nonnull tipString) {
        @strongify(self);
        // update model's valueList
        self.model.valueList = [selectedDataArray mutableCopy];
        // update valueModelArray
        self.valueModelArray = [NSArray yy_modelArrayWithClass:[IMSPopupMultipleSelectModel class] json:selectedDataArray];
        // update tagview datasource
        [self updateTagViewDataSource];
        
        [self.form.tableView beginUpdates];
        [self.form.tableView endUpdates];
        
        // call back
        if (self.didUpdateFormModelBlock) {
            self.didUpdateFormModelBlock(self, self.model, nil);
        }
        
        [self updatePlaceholder];
        
    }];
    
    [self.multipleSelectListView setDidFinishedShowAndHideBlock:^(BOOL isShow) {
        @strongify(self);
        self.model.selected = isShow;
        [self updateArrowButtonAnimation];
        
        // call back
//        if (!isShow && self.didUpdateFormModelBlock) {
//            self.didUpdateFormModelBlock(self, self.model, nil);
//        }
    }];
    
    self.multipleSelectListView.maxCount = self.model.cpnConfig.multipleLimit;
    self.multipleSelectListView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
    
    [self.multipleSelectListView showView];
}

#pragma mark - Getters

- (UILabel *)placeholderLabel {
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = IMS_HEXCOLOR(0xC4C7D1);
        _placeholderLabel.font = [UIFont systemFontOfSize:12];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
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

- (IMSPopupMultipleSelectListView *)multipleSelectListView
{
    if (!_multipleSelectListView) {
        _multipleSelectListView = [[IMSPopupMultipleSelectListView alloc] initWithFrame:CGRectZero];
    }
    return _multipleSelectListView;
}

@end
