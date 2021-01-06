//
//  IMSValuePopupView.h
//  IMSForm
//
//  Created by cjf on 6/1/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMSValuePopupViewDelegate <NSObject>

- (CGFloat)currentValueOffset; //expects value in the range 0.0 - 1.0 
- (void)animationDidStart;

@end

@interface IMSValuePopupView : UIView

@property (nonatomic, weak) id <IMSValuePopupViewDelegate> delegate;

- (UIColor *)color;
- (void)setColor:(UIColor *)color;
- (UIColor *)opaqueColor;

- (void)setTextColor:(UIColor *)textColor;
- (void)setFont:(UIFont *)font;
- (void)setString:(NSString *)string;

- (void)setAnimatedColors:(NSArray *)animatedColors;

- (void)setAnimationOffset:(CGFloat)offset;
- (void)setArrowCenterOffset:(CGFloat)offset;

- (CGSize)popUpSizeForString:(NSString *)string;

- (void)show;
- (void)hide;


@end

NS_ASSUME_NONNULL_END
