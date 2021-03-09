//
//  UIView+Extension.h
//  IMSForm
//
//  Created by cjf on 2019/5/20.
//  Copyright © 2019 Maricle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat bottom;

+ (instancetype)nibView;

- (UIViewController *)viewController;

@end

@interface UIView (Corner)

@property (strong, nonatomic) CAShapeLayer *roundBorderLayer; /**< 圆角边框图层 */

/**
 CJF - 边框

 @param corners 圆角位置
 @param cornerRadii 圆角半径
 @param borderWidth 边框大小
 @param borderColor 边框颜色
 */
- (void)borderWithCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end

NS_ASSUME_NONNULL_END
