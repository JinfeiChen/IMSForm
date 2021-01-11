//
//  BasePickerView.m
//  unknownProjectName
//
//  Created by longli on 2019/7/2.
//  Copyright © 2019 ***** All rights reserved.
//

#import "BasePickerView.h"
#import "PickerViewMacro.h"
@implementation BasePickerView

- (void)initUI {
    self.frame = SCREEN_BOUNDS;
    // 设置子视图的宽度随着父视图变化
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // 背景遮罩图层
    [self addSubview:self.backgroundView];
    // 弹出视图
    [self addSubview:self.alertView];
    // 设置弹出视图子视图
    // 添加顶部标题栏
    [self.alertView addSubview:self.topView];
    // 添加左边取消按钮
    [self.topView addSubview:self.topLeftBtn];
    // 添加中间标题按钮
    [self.topView addSubview:self.titleLabel];
    // 添加右边确定按钮
    [self.topView addSubview:self.topRightBtn];
    // 添加分割线
    [self.topView addSubview:self.topLineView];
    
    [self.alertView addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLineView];
    [self.bottomView addSubview:self.bottomLeftBtn];
    [self.bottomView addSubview:self.bottomRightBtn];
}

#pragma mark - 背景遮罩图层
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:SCREEN_BOUNDS];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2f];
        // 设置子视图的大小随着父视图变化
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapBackgroundView:)];
        [_backgroundView addGestureRecognizer:myTap];
    }
    return _backgroundView;
}

#pragma mark - 弹出视图
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(25, (SCREEN_HEIGHT - kTopViewHeight - kPickerHeight - PV_BOTTOM_MARGIN - kBottomViewHeight)/2, SCREEN_WIDTH-50, kTopViewHeight + kPickerHeight + PV_BOTTOM_MARGIN + kBottomViewHeight)];
        _alertView.backgroundColor = [UIColor whiteColor];
        // 设置子视图的大小随着父视图变化
        _alertView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.masksToBounds = YES;
    }
    return _alertView;
}

#pragma mark - 顶部标题栏视图
- (UIView *)topView {
    if (!_topView) {
        _topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.alertView.frame.size.width, kTopViewHeight + 0.5)];
        _topView.backgroundColor = kPVToolBarColor;
        // 设置子视图的大小随着父视图变化
        _topView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _topView;
}

#pragma mark - 左边取消按钮
- (UIButton *)topLeftBtn {
    if (!_topLeftBtn) {
        _topLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topLeftBtn.frame = CGRectMake(5, 8, 60, 28);
        _topLeftBtn.backgroundColor = kPVToolBarColor;
        _topLeftBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _topLeftBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
        [_topLeftBtn setTitleColor:kDefaultThemeColor forState:UIControlStateNormal];
        [_topLeftBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_topLeftBtn addTarget:self action:@selector(clickTopLeftBtn) forControlEvents:UIControlEventTouchUpInside];
        _topLeftBtn.hidden = YES;
    }
    return _topLeftBtn;
}

#pragma mark - 右边确定按钮
- (UIButton *)topRightBtn {
    if (!_topRightBtn) {
        _topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topRightBtn.frame = CGRectMake(self.alertView.frame.size.width - 65, 8, 60, 28);
        _topRightBtn.backgroundColor = kPVToolBarColor;
        _topRightBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        _topRightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
        [_topRightBtn setTitleColor:kDefaultThemeColor forState:UIControlStateNormal];
        [_topRightBtn setTitle:@"Confirm" forState:UIControlStateNormal];
        [_topRightBtn addTarget:self action:@selector(clickTopRightBtn) forControlEvents:UIControlEventTouchUpInside];
        _topRightBtn.hidden = YES;
    }
    return _topRightBtn;
}

#pragma mark - 中间标题按钮
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.topLeftBtn.frame.origin.x + self.topLeftBtn.frame.size.width + 2, 0, self.alertView.frame.size.width - 2 * (self.topLeftBtn.frame.origin.x + self.topLeftBtn.frame.size.width + 2), kTopViewHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        _titleLabel.font = [UIFont systemFontOfSize:14.0f * kScaleFit];
        _titleLabel.textColor = [kDefaultThemeColor colorWithAlphaComponent:0.8f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark - 分割线
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopViewHeight, self.alertView.frame.size.width, 0.5)];
        _topLineView.backgroundColor = PV_RGB_HEX(0xf1f1f1, 1.0f);
        _topLineView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [self.alertView addSubview:_topLineView];
    }
    return _topLineView;
}


- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, self.alertView.frame.size.height-kBottomViewHeight-0.5, self.alertView.frame.size.width, kBottomViewHeight + 0.5)];
        _bottomView.backgroundColor = kPVToolBarColor;
        // 设置子视图的大小随着父视图变化
        _bottomView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _bottomView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.alertView.frame.size.width, 0.5)];
        _bottomLineView.backgroundColor = PV_RGB_HEX(0xf1f1f1, 1.0f);
        _bottomLineView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [self.alertView addSubview:_bottomLineView];
    }
    return _bottomLineView;
}
- (UIButton *)bottomLeftBtn {
    if (!_bottomLeftBtn) {
        _bottomLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomLeftBtn.frame = CGRectMake(0, 0.5, self.bottomView.width/2, self.bottomView.height);
        _bottomLeftBtn.backgroundColor = kPVToolBarColor;
        _bottomLeftBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _bottomLeftBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
        [_bottomLeftBtn setTitleColor:kDefaultThemeColor forState:UIControlStateNormal];
        [_bottomLeftBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_bottomLeftBtn addTarget:self action:@selector(clickTopLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomLeftBtn;
}

#pragma mark - 右边确定按钮
- (UIButton *)bottomRightBtn {
    if (!_bottomRightBtn) {
        _bottomRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomRightBtn.frame = CGRectMake(self.bottomView.width/2, 0.5, self.bottomView.width/2, self.bottomView.height);
        _bottomRightBtn.backgroundColor = kPVToolBarColor;
        _bottomRightBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        _bottomRightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
        [_bottomRightBtn setTitleColor:kDefaultThemeColor forState:UIControlStateNormal];
        [_bottomRightBtn setTitle:@"Confirm" forState:UIControlStateNormal];
        [_bottomRightBtn addTarget:self action:@selector(clickTopRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomRightBtn;
}

#pragma mark - 点击背景遮罩图层事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    
}

#pragma mark - 取消按钮的点击事件
- (void)clickTopLeftBtn {
    
}

#pragma mark - 确定按钮的点击事件
- (void)clickTopRightBtn {
    
}

#pragma mark - 自定义主题颜色
- (void)setupThemeColor:(UIColor *)themeColor {
    self.topLeftBtn.layer.cornerRadius = 6.0f;
    self.topLeftBtn.layer.borderColor = themeColor.CGColor;
    self.topLeftBtn.layer.borderWidth = 1.0f;
    self.topLeftBtn.layer.masksToBounds = YES;
    [self.topLeftBtn setTitleColor:themeColor forState:UIControlStateNormal];
    
    self.topRightBtn.backgroundColor = themeColor;
    self.topRightBtn.layer.cornerRadius = 6.0f;
    self.topRightBtn.layer.masksToBounds = YES;
    [self.topRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.titleLabel.textColor = [themeColor colorWithAlphaComponent:0.8f];
}

@end
