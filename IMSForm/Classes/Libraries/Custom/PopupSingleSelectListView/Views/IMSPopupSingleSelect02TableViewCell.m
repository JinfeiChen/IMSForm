//
//  IMSPopupSingleSelect02TableViewCell.m
//  Raptor
//
//  Created by cjf on 18/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupSingleSelect02TableViewCell.h"
#import <Masonry/Masonry.h>
#import <IMSForm/IMSFormMacros.h>
#import <IMSForm/IMSFormValidateManager.h>

@interface IMSPopupSingleSelect02TableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation IMSPopupSingleSelect02TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(10);
        make.width.lessThanOrEqualTo(@(IMS_SCREEN_WIDTH - 10 - 60));
    }];

    [self.contentView addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(8);
    }];

    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-10);
    }];

    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(5);
        make.left.height.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
}

- (void)setDataModel:(IMSPopupSingleSelectModel *)dataModel {
    _dataModel = dataModel;
    self.nameLabel.text = [IMSFormValidateManager isEmpty:dataModel.Name] ? @"-" : dataModel.Name;
    self.infoLabel.text = [IMSFormValidateManager isEmpty:dataModel.Contact_Roles__c] ? @"-" : dataModel.Contact_Roles__c;
    self.timeLabel.text = [IMSFormValidateManager isEmpty:dataModel.Phone] ? @"-" : dataModel.Phone;
    if (![IMSFormValidateManager isEmpty:dataModel.RecordTypeName] && ![dataModel.RecordTypeName isEqualToString:@"Individual"]) {
        self.lineLabel.text = [NSString stringWithFormat:@" %@ ", dataModel.RecordTypeName];
    }
}

- (void)setSourceCampaignModel:(IMSPopupSingleSelectModel *)sourceCampaignModel {
    _sourceCampaignModel = sourceCampaignModel;
    self.nameLabel.text = [IMSFormValidateManager isEmpty:sourceCampaignModel.Name] ? @"-" : sourceCampaignModel.Name;
    NSString *status = [IMSFormValidateManager isEmpty:sourceCampaignModel.Status] ? @"-" : sourceCampaignModel.Status;
    self.infoLabel.text = [NSString stringWithFormat:@"%@,%@ ~ %@", status, sourceCampaignModel.StartDate, sourceCampaignModel.EndDate];
    if (![IMSFormValidateManager isEmpty:sourceCampaignModel.Type]) {
        self.lineLabel.text = [NSString stringWithFormat:@" %@ ", sourceCampaignModel.Type];
    }
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.numberOfLines = 0;
        _infoLabel.font = [UIFont systemFontOfSize:13];
        _infoLabel.textColor = self.lineLabel.textColor;
    }
    return _infoLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 2;
        _timeLabel.textColor = self.lineLabel.textColor;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}

- (UILabel *)lineLabel {
    if (_lineLabel == nil) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:243 / 255.0 alpha:1.0];
        _lineLabel.textColor = [UIColor colorWithRed:159 / 255.0 green:161 / 255.0 blue:167 / 255.0 alpha:1.0];
        _lineLabel.font = [UIFont systemFontOfSize:12];
        _lineLabel.layer.cornerRadius = 4.0;
        _lineLabel.layer.masksToBounds = YES;
    }
    return _lineLabel;
}

@end
