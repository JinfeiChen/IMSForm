//
//  IMSFormInputSearchCellDelegate.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <Foundation/Foundation.h>
#import <IMSForm/IMSFormModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMSFormInputSearchCellDelegate <NSObject>

@optional

- (void)customInputSearchWithFormModel:(IMSFormModel *)formModel completation:(void(^)(IMSPopupSingleSelectListView * _Nullable selectListView, NSArray *dataArray))callback;

@end

NS_ASSUME_NONNULL_END
