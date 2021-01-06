//
//  IMSDropHUD.h
//  Pods
//
//  Created by cjf on 5/1/2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <IMSForm/NSString+Extension.h>
#import <IMSForm/UIImage+Bundle.h>

#import <IMSForm/IMSFormMacros.h>
#import <IMSForm/IMSFormType.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSDropView : UIView

@property (nonatomic,assign) CGFloat showTime; /**< 提示框显示时间(单位：秒)，default 1.5 */

@property (strong, nonatomic) UIColor *textColor; /**< 提示文字颜色 */

@property (nonatomic,assign) NSInteger statusStyle;

- (void)alertWithType:(IMSFormMessageType)type message:(NSString *)message; 

- (void)show;

@end

@interface IMSDropHUD : NSObject

+ (void)showAlertWithType:(IMSFormMessageType)type message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
