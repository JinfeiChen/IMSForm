//
//  IMSPopupTreeTabView.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/13.
//

#import <UIKit/UIKit.h>
#import <IMSForm/IMSFormMacros.h>
#import "IMSPopupTreeTabCell.h"
#define TableViewHeight (IMS_SCREEN_HEIGHT*0.4)

NS_ASSUME_NONNULL_BEGIN

@interface IMSPopupTreeTabView : UIView
@property (nonatomic, strong) NSArray *dataArray;
- (void)show:(BOOL)isShowTabHeader andTitle:(NSString *)title;

@property (nonatomic, copy) void (^didSelectItemBlock)(BOOL isShowChildView,IMSFormSelect *didSelectDataModel,NSString *treeTabViewTitleString);
@end

NS_ASSUME_NONNULL_END
