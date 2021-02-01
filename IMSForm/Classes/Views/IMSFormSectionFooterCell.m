//
//  IMSFormSectionFooterCell.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormSectionFooterCell.h"

#import <IMSForm/IMSFormManager.h>

@interface IMSFormSectionFooterCell ()

@property (strong, nonatomic) UILabel *contentLabel; /**< <#property#> */

@end

@implementation IMSFormSectionFooterCell

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
    [self.contentView addSubview:self.contentLabel];
    
    [self updateUI];
}

- (void)updateUI
{
    self.contentView.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.backgroundHexColor]);
    
    self.contentLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.titleHexColor]);
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets inset = self.model.cpnStyle.contentInset;
        inset.bottom = self.model.cpnStyle.contentInset.bottom + self.model.cpnStyle.spacing / 2;
        make.edges.mas_equalTo(self.contentView).with.insets(inset);
    }];
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    self.contentLabel.text = model.title;
}

#pragma mark - Getters

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = IMS_HEXCOLOR(0x000000);
        _contentLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}

@end
