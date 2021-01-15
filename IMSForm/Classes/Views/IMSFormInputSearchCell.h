//
//  IMSFormInputSearchCell.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormTableViewCell.h>
#import <IMSForm/IMSFormInputSearchModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormInputSearchCell : IMSFormTableViewCell

@property (strong, nonatomic) UITextField *textField; /**< <#property#> */
@property (strong, nonatomic) IMSFormInputSearchModel *model; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
