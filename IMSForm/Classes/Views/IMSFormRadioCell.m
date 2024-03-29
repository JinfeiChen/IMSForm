//
//  IMSFormRadioCell.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/11.
//

#import "IMSFormRadioCell.h"
#import "IMSFormSelect.h"
#import "IMSFormRadioModel.h"

@interface IMSFormRadioCell ()
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) NSMutableArray *buttonArrayM;
@end

@implementation IMSFormRadioCell

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
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.top);
        make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
        make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
    }];
    
    [self.bodyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(spacing);
        make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
        make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
//        make.height.mas_equalTo(kIMSFormDefaultHeight);
    }];

//    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.bodyView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
    }];
    
}

#pragma mark - Public Methods
- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self setTitle:model.title required:model.isRequired];
    
    self.infoLabel.text = model.info;
    
    self.bodyView.userInteractionEnabled = model.isEnable;
    self.bodyView.backgroundColor = self.model.isEnable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    
    IMSFormRadioModel *radioModel = (IMSFormRadioModel *)model;
    
    NSArray *dataModelSource = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:radioModel.cpnConfig.dataSource];
    
    if (dataModelSource.count  <= 0) {
        for (UIButton *button in self.buttonArrayM) {
            [button removeFromSuperview];
        }
        [self.buttonArrayM removeAllObjects];
        [self.bodyView addSubview:self.tipLabel];
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bodyView);
            make.height.equalTo(@40);
        }];
        
    }else {
        [self.tipLabel removeFromSuperview];
        
        if (dataModelSource.count != self.buttonArrayM.count) {
            for (UIButton *button in self.buttonArrayM) {
                [button removeFromSuperview];
            }
            [self.buttonArrayM removeAllObjects];
        }
        
        if (dataModelSource.count && !self.buttonArrayM.count) {
            for (int i = 0; i < dataModelSource.count; ++i) {
                UIButton *button = [[UIButton alloc]init];
                button.tag = i;
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [button setImage:[[UIImage bundleImageWithNamed:@"ims-icon-radio-normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                [button setImage:[[UIImage bundleImageWithNamed:@"ims-icon-radio-selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                button.titleEdgeInsets = UIEdgeInsetsMake(0, button.imageView.width+10, 0, 0);
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                button.backgroundColor = [UIColor clearColor];
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                
                [self.bodyView addSubview:button];
                [self.buttonArrayM addObject:button];
            }
            
            UIView *lastView = self.bodyView;
            for (int i = 0; i < self.buttonArrayM.count; ++i) {
                UIButton *button = self.buttonArrayM[i];
                
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (i == 0) {
                        make.top.equalTo(lastView);
                    }else {
                        make.top.equalTo(lastView.mas_bottom);
                    }
                    make.left.equalTo(self.bodyView).offset(0);
                    make.right.equalTo(self.bodyView);
                    make.height.mas_equalTo(40);
                    if (i == self.buttonArrayM.count - 1) make.bottom.equalTo(self.bodyView);
                    
                }];
                lastView = button;
            }
        }
        
        [self.model.valueList removeAllObjects];
        for (int i = 0; i < dataModelSource.count; ++i) {
            IMSFormSelect *selectModel = dataModelSource[i];
            UIButton *button = self.buttonArrayM[i];
            [button setTitle:[NSString stringWithFormat:@"%@",selectModel.label ?: selectModel.value] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%@",selectModel.label ?: selectModel.value] forState:UIControlStateSelected];
            button.enabled = selectModel.enable;
            button.selected = selectModel.selected;
            
            button.tintColor = button.enabled ? IMS_HEXCOLOR([NSString intRGBWithHex:model.cpnStyle.tintHexColor]) : [UIColor grayColor];
           
            if (selectModel.selected) [self.model.valueList addObject:[selectModel yy_modelToJSONObject]];
        }
    }
}

- (void)buttonAction:(UIButton *)button {
    
    IMSFormRadioModel *radioModel = (IMSFormRadioModel *)self.model;
    if (button.selected && radioModel.cpnConfig.deselect) {
        [self.model.valueList removeAllObjects];
        NSMutableArray *deselectArrayM = [NSMutableArray arrayWithArray:radioModel.cpnConfig.dataSource];
        NSMutableDictionary *deselectDataDict = [NSMutableDictionary dictionaryWithDictionary:radioModel.cpnConfig.dataSource[button.tag]];
        button.selected = NO;
        [deselectDataDict setValue:@(NO) forKey:@"selected"];
        if (self.didUpdateFormModelBlock) {
            self.didUpdateFormModelBlock(self, self.model, nil);
        }
        [deselectArrayM replaceObjectAtIndex:button.tag withObject:deselectDataDict];
        radioModel.cpnConfig.dataSource = deselectArrayM;
        return;
    }
    
    if (button.selected) return;
    
    [self.model.valueList removeAllObjects];
    NSMutableArray *selectArrayM = [NSMutableArray array];
    for (int i = 0; i < self.buttonArrayM.count; ++i) {
        UIButton *allButton = self.buttonArrayM[i];
        NSMutableDictionary *selectDataDictM = [NSMutableDictionary dictionaryWithDictionary:radioModel.cpnConfig.dataSource[i]];
        allButton.selected = (button.tag == allButton.tag);
        [selectDataDictM setValue:@(allButton.selected) forKey:@"selected"];
        [selectArrayM addObject:selectDataDictM];
        if ( allButton.selected) {
            [self.model.valueList addObject:selectDataDictM];
            if (self.didUpdateFormModelBlock) {
                self.didUpdateFormModelBlock(self, self.model, nil);
            }
        }
    }
    radioModel.cpnConfig.dataSource = selectArrayM;
}

- (NSMutableArray *)buttonArrayM {
    if (_buttonArrayM == nil) {
        _buttonArrayM = [[NSMutableArray alloc] init];
    }
    return _buttonArrayM;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.text = @"No Data";
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

@end
