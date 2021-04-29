//
//  IMSFormManager+HUD.h
//  IMSForm
//
//  Created by cjf on 29/4/2021.
//

#import <IMSForm/IMSFormManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormManager (HUD)

- (void)showInfo:(NSString *)msg;
- (void)showSuccess:(NSString *)msg;
- (void)showError:(NSString *)msg;
- (void)showWarning:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
