//
//  IMSFormTableViewCell.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormTableViewCell.h"

@implementation IMSFormTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Getters

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = IMS_HEXCOLOR(self.model.cpnConfig.style.titleHexColor);
        _titleLabel.font = [UIFont systemFontOfSize:self.model.cpnConfig.style.titleFontSize weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = IMS_HEXCOLOR(self.model.cpnConfig.style.infoHexColor);
        _infoLabel.font = [UIFont systemFontOfSize:self.model.cpnConfig.style.infoFontSize weight:UIFontWeightRegular];
    }
    return _infoLabel;
}

- (UIView *)bodyView
{
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
    }
    return _bodyView;
}

@end
