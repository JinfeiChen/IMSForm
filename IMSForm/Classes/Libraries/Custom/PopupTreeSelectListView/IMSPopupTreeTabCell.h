//
//  IMSPopupTreeTabCell.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/13.
//

#import <UIKit/UIKit.h>
#import "IMSFormSelect.h"
#import <IMSForm/IMSFormMacros.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSPopupTreeTabCell : UITableViewCell
- (void)setupData:(IMSFormSelect *)model andIsLast:(BOOL)isLast;
@end

NS_ASSUME_NONNULL_END
