//
//  IMSFormSwitchCell.m
//  IMSForm
//
//  Created by cjf on 6/1/2021.
//

#import "IMSFormSwitchCell.h"

#import <IMSForm/IMSFormManager.h>

@interface IMSFormSwitchCell ()

@property (strong, nonatomic) UISwitch *mySwitch; /**< <#property#> */

@end

@implementation IMSFormSwitchCell

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
    [self.bodyView addSubview:self.mySwitch];
    
    [self updateUI];
}

- (void)updateUI
{
    self.contentView.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.backgroundHexColor]);
    
    self.titleLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.titleHexColor]);
    self.titleLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.titleFontSize weight:UIFontWeightMedium];
    
    self.infoLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.infoFontSize weight:UIFontWeightRegular];
    self.infoLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.infoHexColor]);
    
    self.bodyView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    self.bodyView.userInteractionEnabled = self.model.isEditable;
    
    self.mySwitch.onTintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
    
    CGFloat spacing = self.model.cpnStyle.spacing;
    // 只支持横向布局 IMSFormLayoutType_Horizontal
    [self.bodyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(spacing);
        make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
        make.height.mas_equalTo(kIMSFormDefaultHeight);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.top + 8);
        make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
        make.right.mas_equalTo(self.bodyView.mas_left).mas_offset(-self.model.cpnStyle.spacing);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    [self.mySwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bodyView);
        if ([self.model.cpnStyle.bodyAlign isEqualToString:IMSFormBodyAlign_Left]) {
            make.left.mas_equalTo(self.bodyView).offset(spacing);
        } else {
            make.right.mas_equalTo(self.bodyView).offset(-spacing);
        }
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

#pragma mark - Private Methods

// 清除重用数据
- (void)clearReuseData
{
    self.titleLabel.text = @"";
    self.infoLabel.text = @"";
    self.mySwitch.on = NO;
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self clearReuseData];
    [self setTitle:model.title required:model.isRequired];
    
    self.infoLabel.text = model.info;
    
    self.mySwitch.on = [model.value boolValue];
}

#pragma mark - Actions

- (void)switchAction
{
    // update model value
    self.model.value = self.mySwitch.on ? @"1" : @"0";
    
    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change] || [self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Blur]) {
        [self validate];
    }
}

#pragma mark - Getters

- (UISwitch *)mySwitch
{
    if (!_mySwitch) {
        _mySwitch = [[UISwitch alloc] init];
        [_mySwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mySwitch;
}

@end
