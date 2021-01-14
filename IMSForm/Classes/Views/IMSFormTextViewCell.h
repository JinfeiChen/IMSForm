//
//  IMSFormTextViewCell.h
//  IMSForm
//
//  Created by cjf on 6/1/2021.
//

#import <IMSForm/IMSFormTableViewCell.h>
#import <IMSForm/IMSFormTextViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormTextViewCell : IMSFormTableViewCell

@property (strong, nonatomic) YYTextView *textView; /**< <#property#> */

@property (strong, nonatomic) IMSFormTextViewModel *model; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
