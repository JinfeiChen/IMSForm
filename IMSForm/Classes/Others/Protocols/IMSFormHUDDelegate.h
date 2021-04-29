//
//  IMSFormHUDDelegate.h
//  IMSForm
//
//  Created by cjf on 29/4/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMSFormHUDDelegate <NSObject>

@optional

- (void)showInfo:(NSString *)msg;
- (void)showSuccess:(NSString *)msg;
- (void)showError:(NSString *)msg;
- (void)showWarning:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
