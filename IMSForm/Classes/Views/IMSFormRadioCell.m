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
    
    self.bodyView.userInteractionEnabled = model.isEditable;
    self.bodyView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    
    IMSFormRadioModel *radioModel = (IMSFormRadioModel *)model;
    
    NSArray *dataModelSource = radioModel.cpnConfig.dataSource;
    
    if (dataModelSource.count != self.buttonArrayM.count) {
        for (UIButton *button in self.buttonArrayM) {
            [button removeFromSuperview];
        }
        [self.buttonArrayM removeAllObjects];
    }
    
    if (dataModelSource.count && !self.buttonArrayM.count) {
        for (int i = 0; i < dataModelSource.count; ++i) {
            //            IMSFormSelect *selectModel = dataModelSource[i];
            UIButton *button = [[UIButton alloc]init];
            button.tag = i;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setImage:[[UIImage bundleImageWithNamed:@"ims-icon-radio-normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [button setImage:[[UIImage bundleImageWithNamed:@"ims-icon-radio-selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
            button.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:model.cpnStyle.tintHexColor]);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor whiteColor];
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
                make.left.equalTo(self.bodyView).offset(10);
                make.right.equalTo(self.bodyView);
                make.height.mas_equalTo(40);
                if (i == self.buttonArrayM.count - 1) make.bottom.equalTo(self.bodyView);
                
            }];
            lastView = button;
        }
    }
    
    for (int i = 0; i < dataModelSource.count; ++i) {
        IMSFormSelect *selectModel = dataModelSource[i];
        UIButton *button = self.buttonArrayM[i];
        [button setTitle:[NSString stringWithFormat:@"   %@",selectModel.label ?:selectModel.value] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"   %@",selectModel.label ?: selectModel.value] forState:UIControlStateSelected];
        button.backgroundColor = self.bodyView.backgroundColor;
        button.selected = selectModel.selected;
    }
}

- (void)buttonAction:(UIButton *)button {
    
    [self.model.valueList removeAllObjects];
    IMSFormRadioModel *radioModel = (IMSFormRadioModel *)self.model;
    if (button.selected) {
        IMSFormSelect *selectModel = radioModel.cpnConfig.dataSource[button.tag];
        selectModel.selected = button.selected = NO;
        if (self.didUpdateFormModelBlock) {
            self.didUpdateFormModelBlock(self, self.model, selectModel);
        }
        return;
    }
    
    for (int i = 0; i < self.buttonArrayM.count; ++i) {
        UIButton *allButton = self.buttonArrayM[i];
        IMSFormSelect *selectModel = radioModel.cpnConfig.dataSource[i];
        selectModel.selected =  allButton.selected = (button.tag == allButton.tag);
        if (selectModel.selected) {
            [self.model.valueList addObject:selectModel];
            if (self.didUpdateFormModelBlock) {
                self.didUpdateFormModelBlock(self, self.model, selectModel);
            }
//            if (self.customDidSelectedBlock) {
//                self.customDidSelectedBlock(self, self.model, selectModel);
//            }
        }
    }
}

- (NSMutableArray *)buttonArrayM {
    if (_buttonArrayM == nil) {
        _buttonArrayM = [[NSMutableArray alloc] init];
    }
    return _buttonArrayM;
}

@end
