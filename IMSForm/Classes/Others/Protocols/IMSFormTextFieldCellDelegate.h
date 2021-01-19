//
//  IMSFormTextFieldCellDelegate.h
//  IMSForm
//
//  Created by cjf on 19/1/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class IMSPopupSingleSelectListView, IMSFormModel;
@protocol IMSFormTextFieldCellDelegate <NSObject>

- (IMSPopupSingleSelectListView *)customPrefixTextFieldCellSelectListViewWithFormModel:(IMSFormModel *)formModel; // 自定义单选列表视图
- (IMSPopupSingleSelectListView *)customSuffixTextFieldCellSelectListViewWithFormModel:(IMSFormModel *)formModel; // 自定义单选列表视图

@end

NS_ASSUME_NONNULL_END
