//
//  UIView+Extension.m
//  IMSForm
//
//  Created by cjf on 2019/5/20.
//  Copyright © 2019 Maricle. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>
#import <IMSForm/NSBundle+ims.h>

@implementation UIView (Extension)

#pragma mark - x
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return CGRectGetMinX(self.frame);
}

#pragma mark - y
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return CGRectGetMinY(self.frame);
}

#pragma mark - maxX
- (void)setMaxX:(CGFloat)maxX {
    self.x = maxX - self.width;
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

#pragma mark - maxY
- (void)setMaxY:(CGFloat)maxY {
    self.y = maxY - self.height;
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

#pragma mark - centerX
- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

#pragma mark - centerY
- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

#pragma mark - width
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

#pragma mark - height
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

#pragma mark - size
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

#pragma mark - orgin
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

#pragma mark  - bottom
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)bottom {
    CGRect frame = self.frame;
    return CGRectGetMinY(frame) + CGRectGetHeight(frame);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // 使用设置frame起作用的代码, 取消autoresizing布局
    self.autoresizingMask = UIViewAutoresizingNone;
}

+ (instancetype)nibView
{
    for (id subView in [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]) {
        if ([subView isKindOfClass:[self class]]) {
            return subView;
        }
    }
    return [[[self class] alloc] init];
}

- (UIViewController *)viewController
{
    UIResponder *responder = self.nextResponder;
    do{
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    }while (responder);

    return nil;
}

@end

static NSString *cjfRoundBorderLayerKey = @"cjfRoundBorderLayerKey"; //圆角边框key

@implementation UIView (Corner)

- (void)setRoundBorderLayer:(CAShapeLayer *)roundBorderLayer
{
    objc_setAssociatedObject(self, &cjfRoundBorderLayerKey, roundBorderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)roundBorderLayer
{
    return objc_getAssociatedObject(self, &cjfRoundBorderLayerKey);
}

- (void)borderWithCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    if (self.roundBorderLayer) {
        [self.roundBorderLayer removeFromSuperlayer];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    path.lineCapStyle = kCGLineCapButt;
    path.lineJoinStyle = kCGLineJoinMiter;
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.lineWidth = borderWidth;
    mask.lineCap = kCALineCapSquare;
    // 带边框则两个颜色不要设置成一样即可
    mask.strokeColor = borderColor.CGColor;
    mask.fillColor = [UIColor clearColor].CGColor;
    mask.path = path.CGPath;
    self.roundBorderLayer = mask;
    [self.roundBorderLayer removeFromSuperlayer];
    [self.layer addSublayer:mask];
}

@end
