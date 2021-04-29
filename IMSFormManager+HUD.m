//
//  IMSFormManager+HUD.m
//  IMSForm
//
//  Created by cjf on 29/4/2021.
//

#import "IMSFormManager+HUD.h"
#import <IMSForm/IMSDropHUD.h>

@implementation IMSFormManager (HUD)

- (void)showInfo:(NSString *)msg
{
    if (self.hudDelegate && [self.hudDelegate respondsToSelector:@selector(showInfo:)]) {
        [self.hudDelegate showInfo:msg];
        return;
    }
    [IMSDropHUD showAlertWithType:IMSFormMessageType_Info message:msg];
}

- (void)showSuccess:(NSString *)msg
{
    if (self.hudDelegate && [self.hudDelegate respondsToSelector:@selector(showSuccess:)]) {
        [self.hudDelegate showSuccess:msg];
        return;
    }
    [IMSDropHUD showAlertWithType:IMSFormMessageType_Success message:msg];
}

- (void)showError:(NSString *)msg
{
    if (self.hudDelegate && [self.hudDelegate respondsToSelector:@selector(showError:)]) {
        [self.hudDelegate showError:msg];
        return;
    }
    [IMSDropHUD showAlertWithType:IMSFormMessageType_Error message:msg];
}

- (void)showWarning:(NSString *)msg
{
    if (self.hudDelegate && [self.hudDelegate respondsToSelector:@selector(showWarning:)]) {
        [self.hudDelegate showWarning:msg];
        return;
    }
    [IMSDropHUD showAlertWithType:IMSFormMessageType_Warning message:msg];
}

@end
