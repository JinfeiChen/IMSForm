//
//  IMSFormSliderCell.m
//  IMSForm
//
//  Created by cjf on 6/1/2021.
//

#import "IMSFormSliderCell.h"
#import <IMSForm/IMSValueTrackingSlider.h>
#import <IMSForm/NSString+Extension.h>

@interface IMSFormSliderCell ()

@property (nonatomic, strong) IMSValueTrackingSlider *sliderView;

@end

@implementation IMSFormSliderCell

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
    [self.bodyView addSubview:self.sliderView];
    
    self.bodyView.layer.masksToBounds = NO;
    
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
    if ([self.model.cpnStyle.layout isEqualToString:IMSFormLayoutType_Horizontal]) {
        self.bodyView.backgroundColor = [UIColor whiteColor];
        
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
        [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bodyView).with.insets(UIEdgeInsetsMake(0, 10, 0, 10));
            make.height.mas_equalTo(kIMSFormDefaultHeight);
        }];
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];
    } else {
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
        [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bodyView).with.insets(UIEdgeInsetsMake(0, 10, 0, 10));
            make.height.mas_equalTo(kIMSFormDefaultHeight);
        }];
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];
    }
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self setTitle:model.title required:model.isRequired];
    
    self.infoLabel.text = model.info;
    
    self.bodyView.userInteractionEnabled = model.isEditable;
    
    [self.sliderView setMaxFractionDigitsDisplayed:model.cpnConfig.precision];
    self.sliderView.minimumValue = model.cpnConfig.min;
    self.sliderView.maximumValue = model.cpnConfig.max;
    CGFloat value = MAX(model.value.floatValue, model.cpnConfig.min);
    value = MIN(value, model.cpnConfig.max);
    self.sliderView.value = value;
}

#pragma mark - Actions

- (void)sliderAction
{
    // update model value
    self.model.value = [NSString getRoundFloat:self.sliderView.value withPrecisionNum:self.model.cpnConfig.precision];
    
    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
    // text type limit, blur 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Blur] || [self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }
}

#pragma mark - Getters

- (IMSValueTrackingSlider *)sliderView {
    if (_sliderView == nil) {
        _sliderView = [[IMSValueTrackingSlider alloc] init];
//        _sliderView.minimumValue = 0;
//        _sliderView.maximumValue = 100;
        _sliderView.font = [UIFont systemFontOfSize:14];
//        _sliderView.popUpViewColor = [UIColor clearColor];
        [_sliderView setMaxFractionDigitsDisplayed:0]; // 小数点位数
        [_sliderView addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sliderView;
}

@end
