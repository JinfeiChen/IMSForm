//
//  IMSPopupMultipleSelectTableViewSectionHeaderView.m
//  Raptor
//
//  Created by cjf on 22/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupMultipleSelectTableViewSectionHeaderView.h"
#import <Masonry/Masonry.h>

@interface IMSPopupMultipleSelectTableViewSectionHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation IMSPopupMultipleSelectTableViewSectionHeaderView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = IMS_HEXCOLOR(0xF5F6F9);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.left.equalTo(self).offset(10);
        }];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString {
    titleString = titleString ? : @"-";
    if ([titleString containsString:@"*"]) {
        NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc]initWithString:titleString];
        [mutString setAttributes:@{ NSForegroundColorAttributeName: [UIColor redColor] } range:NSMakeRange(0, 1)];
        self.titleLabel.attributedText = mutString;
    } else {
        self.titleLabel.text = titleString;
    }
}

- (void)setupData:(NSString *)titleString andBackColor:(UIColor *)backColor andTitleColor:(UIColor *)titleColor andTitleFont:(UIFont *)titleFont {
    self.titleLabel.text = titleString;
    self.backgroundColor = backColor;
    self.titleLabel.font = titleFont;
    self.titleLabel.textColor = titleColor;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = IMS_HEXCOLOR(0x565465);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

@end
