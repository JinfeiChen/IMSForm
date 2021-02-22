//
//  CJFTableErrorNetworkView.m
//  caricature
//
//  Created by cjf on 2019/8/26.
//

#import "CJFTableErrorNetworkView.h"

@interface CJFTableErrorNetworkView ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation CJFTableErrorNetworkView

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setBtnTitle:(NSString *)btnTitle
{
    _btnTitle = btnTitle;
    [self.button setTitle:btnTitle forState:UIControlStateNormal];
    [self.button setTitle:btnTitle forState:UIControlStateSelected];
}

- (IBAction)clickAction:(UIButton *)sender
{
    if (_clickHandler) {
        _clickHandler(sender);
    }
}

@end
