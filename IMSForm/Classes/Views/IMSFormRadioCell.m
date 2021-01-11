//
//  IMSFormRadioCell.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/11.
//

#import "IMSFormRadioCell.h"
#import "IMSFormSelect.h"

@implementation IMSFormRadioModel

@end

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
//        make.height.mas_equalTo(kIMSFormDefaultHeight);
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

#pragma mark - Public Methods
- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self setTitle:model.title required:model.isRequired];
    
    self.infoLabel.text = model.info;
    
    self.bodyView.userInteractionEnabled = model.isEditable;
    
    
    NSArray *dataModelSource = [NSArray yy_modelArrayWithClass:[IMSFormRadioModel class] json:model.cpnConfig.selectDataSource];
    
    if (dataModelSource.count != self.buttonArrayM.count) {
        for (UIButton *button in self.buttonArrayM) {
            [button removeFromSuperview];
        }
        [self.buttonArrayM removeAllObjects];
    }
    
    if (dataModelSource.count && !self.buttonArrayM.count) {
        for (int i = 0; i < dataModelSource.count; ++i) {
            IMSFormRadioModel *selectModel = dataModelSource[i];
            UIButton *button = [[UIButton alloc]init];
            button.tag = i;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setImage:[UIImage bundleImageWithNamed:selectModel.normalImageName] forState:UIControlStateNormal];
            [button setImage:[UIImage bundleImageWithNamed:selectModel.selectedImageName] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
    
            [self.bodyView addSubview:button];
            [self.buttonArrayM addObject:button];
        }
        
        [self.buttonArrayM mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
        [self.buttonArrayM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.left.equalTo(self.bodyView).offset(10);
            make.right.equalTo(self.bodyView);
        }];
    }
    
    for (int i = 0; i < dataModelSource.count; ++i) {
        IMSFormRadioModel *selectModel = dataModelSource[i];
        UIButton *button = self.buttonArrayM[i];
        [button setTitle:[NSString stringWithFormat:@"   %@",selectModel.value] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"   %@",selectModel.value] forState:UIControlStateSelected];
        button.selected = selectModel.selected;
    }
    
}

- (void)buttonAction:(UIButton *)button {
    if (button.selected) return;
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.buttonArrayM.count; ++i) {
        UIButton *allButton = self.buttonArrayM[i];
        NSDictionary *dataDict = self.model.cpnConfig.selectDataSource[i];
        NSMutableDictionary *dataDictM = dataDict.mutableCopy;
        allButton.selected = (button.tag == allButton.tag);
        [dataDictM setValue:@(allButton.selected) forKey:@"selected"];
        [resultArray addObject:dataDictM];
    }
    self.model.cpnConfig.selectDataSource = resultArray;
}

- (NSMutableArray *)buttonArrayM {
    if (_buttonArrayM == nil) {
        _buttonArrayM = [[NSMutableArray alloc] init];
    }
    return _buttonArrayM;
}

@end
