//
//  IMSFormSelectCell.h
//  IMSForm
//
//  Created by cjf on 8/1/2021.
//

#import <IMSForm/IMSForm.h>

#import <IMSForm/IMSPopupSingleSelectListView.h>
#import <IMSForm/IMSPopupMultipleSelectListView.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormSelectCell : IMSFormTableViewCell

@property (strong, nonatomic) IMSPopupSingleSelectListView *singleSelectListView; /**< <#property#> */
@property (strong, nonatomic) IMSPopupMultipleSelectListView *multipleSelectListView; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
