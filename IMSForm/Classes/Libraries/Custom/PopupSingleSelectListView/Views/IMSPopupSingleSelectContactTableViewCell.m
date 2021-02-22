//
//  IMSPopupSingleSelectContactTableViewCell.m
//  Raptor
//
//  Created by cjf on 18/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupSingleSelectContactTableViewCell.h"
#import <Masonry/Masonry.h>
#import <IMSForm/IMSFormValidateManager.h>

@interface IMSPopupSingleSelectContactTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *roleLabel;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation IMSPopupSingleSelectContactTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.selectButton];
    [self.selectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@(kWidthResult(12)));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(10);
        make.width.lessThanOrEqualTo(@(IMS_SCREEN_WIDTH - 10 - 60));
    }];

    [self.contentView addSubview:self.roleLabel];
    [self.roleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(8);
    }];

    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.selectButton.mas_left).offset(-10);
    }];

    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(5);
        make.left.height.equalTo(self.nameLabel);
        make.right.equalTo(self.phoneLabel);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
}

#pragma mark - Setters

- (void)setModel:(IMSPopupSingleSelectContactModel *)model {
    _model = model;

    self.nameLabel.text = [IMSFormValidateManager isEmpty:model.name] ? @"N/A" : (model.name ? : model.label);
    if (![IMSFormValidateManager isEmpty:model.role]) {
        self.roleLabel.text = [NSString stringWithFormat:@" %@ ", (model.role ? : @"N/A")];
    }
    self.phoneLabel.text = [IMSFormValidateManager isEmpty:model.phone] ? @"N/A" : model.phone;
    self.infoLabel.text = [IMSFormValidateManager isEmpty:model.info] ? @"N/A" : model.info;
    self.selectButton.selected = model.selected;
    self.selectButton.tintColor = self.tintColor;
    
    UIColor *color = model.enable ? [UIColor darkTextColor] : IMS_HEXCOLOR(0xA4ABBF);
    UIColor *color2 = model.enable ? [UIColor lightGrayColor] : IMS_HEXCOLOR(0xA4ABBF);
    self.nameLabel.textColor = color;
    self.roleLabel.textColor = color2;
    self.phoneLabel.textColor = color2;
    self.infoLabel.textColor = color2;
    self.selectButton.tintColor = model.enable ? self.tintColor : [UIColor lightGrayColor];
    self.selectButton.hidden = !model.enable;
}

#pragma mark - Getters

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel {
    if (_phoneLabel == nil) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.numberOfLines = 0;
        _phoneLabel.font = [UIFont systemFontOfSize:11];
        _phoneLabel.textColor = self.roleLabel.textColor;
    }
    return _phoneLabel;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.numberOfLines = 2;
        _infoLabel.textColor = self.roleLabel.textColor;
        _infoLabel.font = [UIFont systemFontOfSize:11];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

- (UILabel *)roleLabel {
    if (_roleLabel == nil) {
        _roleLabel = [[UILabel alloc] init];
        _roleLabel.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:243 / 255.0 alpha:1.0];
        _roleLabel.textColor = [UIColor colorWithRed:159 / 255.0 green:161 / 255.0 blue:167 / 255.0 alpha:1.0];
        _roleLabel.font = [UIFont systemFontOfSize:12];
        _roleLabel.layer.cornerRadius = 4.0;
        _roleLabel.layer.masksToBounds = YES;
    }
    return _roleLabel;
}

- (UIButton *)selectButton {
    if (_selectButton == nil) {
        _selectButton = [[UIButton alloc] init];
        UIImage *normalImage = [[UIImage bundleImageWithNamed:@"ims-icon-radio-normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_selectButton setImage:normalImage forState:UIControlStateNormal];
        UIImage *selectedImage = [[UIImage bundleImageWithNamed:@"ims-icon-radio-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_selectButton setImage:selectedImage forState:UIControlStateSelected];
        _selectButton.tintColor = [UIColor colorWithRed:255/255.0 green:194/255.0 blue:76/255.0 alpha:1.0];
        _selectButton.userInteractionEnabled = NO;
    }
    return _selectButton;
}

@end
