//
//  IMSPopupMultipleSelectTableViewCell.m
//  Raptor
//
//  Created by cjf on 22/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupMultipleSelectTableViewCell.h"
#import <Masonry/Masonry.h>
#import <IMSForm/UIImage+Bundle.h>

@interface IMSPopupMultipleSelectTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation IMSPopupMultipleSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.selectButton];
    [self.selectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@(kWidthResult(12)));
    }];

    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kHeightResult(10));
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.selectButton.mas_left).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-kHeightResult(10));
    }];

    [self.contentView addSubview:self.lineLabel];
    [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.selectButton);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Setters

- (void)setModel:(IMSPopupMultipleSelectModel *)model {
    _model = model;
    
    self.nameLabel.text = model.value ? : @"-";

    if (!model.isEnable) {
        self.nameLabel.textColor = IMS_HEXCOLOR(0xA4ABBF);
        self.selectButton.hidden = YES;
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.selectButton.hidden = NO;
        self.selectButton.selected = model.isSelected;
    }
    
    self.selectButton.tintColor = self.tintColor;
}

#pragma mark - Getters

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UIButton *)selectButton {
    if (_selectButton == nil) {
        _selectButton = [[UIButton alloc] init];
        UIImage *normalImage = [[UIImage bundleImageWithNamed:@"ims-icon-checkbox-normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_selectButton setImage:normalImage forState:UIControlStateNormal];
        UIImage *selectedImage = [[UIImage bundleImageWithNamed:@"ims-icon-checkbox-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_selectButton setImage:selectedImage forState:UIControlStateSelected];
        _selectButton.userInteractionEnabled = NO;
        _selectButton.tintColor = [UIColor colorWithRed:255/255.0 green:194/255.0 blue:76/255.0 alpha:1.0];
    }
    return _selectButton;
}

- (UILabel *)lineLabel {
    if (_lineLabel == nil) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = IMS_HEXCOLOR(0xE1E8EC);
    }
    return _lineLabel;
}

@end
