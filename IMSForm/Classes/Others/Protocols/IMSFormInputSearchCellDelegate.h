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

- (IMSPopupSingleSelectListView *)customInputSearchSelectListView;

@end

NS_ASSUME_NONNULL_END
