//
//  IMSFormSelectView.m
//  IMSForm
//
//  Created by cjf on 18/1/2021.
//

#import "IMSFormSelectView.h"
#import <IMSForm/UIImage+Bundle.h>

@interface IMSFormSelectView ()

@property (strong, nonatomic) UIImageView *indicatorView; /**< <#property#> */

@end

@implementation IMSFormSelectView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        CGFloat indicatorWidth = 12.0;
        [self addSubview:self.indicatorView];
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-10);
            make.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(indicatorWidth);
        }];
        
        [self addSubview:self.textLabel];
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 10, 0, 10 + indicatorWidth + 5);
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(padding);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    self.selected = !self.isSelected;
//    [self updateArrowButtonAnimation];
    
    if (self.didSelectBlock) {
        self.didSelectBlock(tapGesture);
    }
}

- (void)updateArrowButtonAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.isSelected) {
            self.indicatorView.transform = CGAffineTransformMakeRotation(M_PI_2);
        } else {
            self.indicatorView.transform = CGAffineTransformIdentity;
        }
    }];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    [self updateArrowButtonAnimation];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    
    self.backgroundColor = tintColor;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"N/A";
        _textLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _textLabel;
}

- (UIImageView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc] init];
        _indicatorView.image = [UIImage bundleImageWithNamed:@"ims-icon-right"];
    }
    return _indicatorView;
}

@end
