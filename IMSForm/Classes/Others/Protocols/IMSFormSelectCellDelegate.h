//
//  IMSFormSelectCellDelegate.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <Foundation/Foundation.h>
#import <IMSForm/IMSFormModel.h>
#import <IMSForm/IMSPopupSingleSelectListView.h>
#import <IMSForm/IMSPopupMultipleSelectListView.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMSFormSelectCellDelegate <NSObject>

@optional

- (IMSPopupSingleSelectListView *)customSingleSelectListViewWithFormModel:(IMSFormModel *)formModel; // 自定义单选列表视图
- (IMSPopupMultipleSelectListView *)customMultipleSelectListViewWithFormModel:(IMSFormModel *)formModel; // 自定义多选列表视图

@end

NS_ASSUME_NONNULL_END
