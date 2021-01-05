//
//  IMSFormTableViewCell.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormTableViewCell.h"

#import <IMSForm/IMSFormManager.h>

@interface IMSFormTableViewCell ()

@property (strong, nonatomic) IMSFormModel *model; /**< <#property#> */
//@property (weak, nonatomic) UITableView *tableView; /**< <#property#> */

@end

@implementation IMSFormTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(IMSFormManager *)form
{
    _model = model;
    _form = form;
}

- (void)setTitle:(NSString *)title required:(BOOL)required
{
    NSString *text = [NSString stringWithFormat:@"%@%@", required ? @"* " : @"", title];
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:text];
    [mAttr addAttributes:@{
         NSFontAttributeName: [UIFont systemFontOfSize:16.0],
         NSForegroundColorAttributeName: [UIColor redColor]
    } range:required ? NSMakeRange(0, 1) : NSMakeRange(0, 0)];
    self.titleLabel.attributedText = mAttr;
}

- (UIKeyboardType)keyboardWithTextType:(IMSFormTextType)textType
{
    if ([textType isEqualToString:IMSFormTextType_URL]) {
        return UIKeyboardTypeURL;
    } else if ([textType isEqualToString: IMSFormTextType_Email]) {
        return UIKeyboardTypeEmailAddress;
    } else if ([textType isEqualToString:IMSFormTextType_Money]) {
        return UIKeyboardTypeASCIICapable;
    } else if ([textType isEqualToString:IMSFormTextType_Phone]) {
        return UIKeyboardTypePhonePad;
    } else if ([textType isEqualToString:IMSFormTextType_Number]) {
        return UIKeyboardTypeNumberPad;
    } else if ([textType isEqualToString:IMSFormTextType_Password]) {
        return UIKeyboardTypeNumbersAndPunctuation;
    } else if ([textType isEqualToString:IMSFormTextType_IDCard]) {
        return UIKeyboardTypeASCIICapableNumberPad;
    } else {
        return UIKeyboardTypeDefault;
    }
}

#pragma mark - Getters

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.titleHexColor]);
        _titleLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.titleFontSize weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.infoHexColor]);
        _infoLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.infoFontSize weight:UIFontWeightRegular];
    }
    return _infoLabel;
}

- (UIView *)bodyView
{
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.layer.cornerRadius = 8.0;
        _bodyView.layer.masksToBounds = YES;
    }
    return _bodyView;
}

@end