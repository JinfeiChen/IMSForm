//
//  IMSPopupMultipleSelectTableViewSectionHeaderView.h
//  Raptor
//
//  Created by cjf on 22/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSPopupMultipleSelectTableViewSectionHeaderView : UIView

@property (nonatomic, copy) NSString *titleString;

- (void)setupData:(NSString *)titleString andBackColor:(UIColor *)backColor andTitleColor:(UIColor *)titleColor andTitleFont:(UIFont *)titleFont;

@end

NS_ASSUME_NONNULL_END
