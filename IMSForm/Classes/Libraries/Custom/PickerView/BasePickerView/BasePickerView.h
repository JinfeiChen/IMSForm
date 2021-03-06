//
//  BasePickerView.h
//  unknownProjectName
//
//  Created by longli on 2019/7/2.
//  Copyright © 2019 ***** All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasePickerView : UIView
// 背景视图
@property (nonatomic, strong) UIView *backgroundView;
// 弹出视图
@property (nonatomic, strong) UIView *alertView;
// 顶部视图
@property (nonatomic, strong) UIView *topView;
// 左边取消按钮
@property (nonatomic, strong) UIButton *topLeftBtn;
// 右边确定按钮
@property (nonatomic, strong) UIButton *topRightBtn;
// 中间标题
@property (nonatomic, strong) UILabel *titleLabel;
// 分割线视图
@property (nonatomic, strong) UIView *topLineView;
// 底部视图
@property (nonatomic, strong) UIView *bottomView;
// 左边取消按钮
@property (nonatomic, strong) UIButton *bottomLeftBtn;
// 右边确定按钮
@property (nonatomic, strong) UIButton *bottomRightBtn;
// 分割线视图
@property (nonatomic, strong) UIView *bottomLineView;


/** 初始化子视图 */
- (void)initUI;

/** 点击背景遮罩图层事件 */
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender;

/** 取消按钮的点击事件 */
- (void)clickLeftBtn;

/** 确定按钮的点击事件 */
- (void)clickRightBtn;

/** 自定义主题颜色 */
- (void)setupThemeColor:(UIColor *)themeColor;
@end

NS_ASSUME_NONNULL_END
