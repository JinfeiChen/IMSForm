//
//  IMSFormCurrencyCell.h
//  IMSForm
//
//  Created by cjf on 22/1/2021.
//

#import <IMSForm/IMSFormTableViewCell.h>
#import <IMSForm/IMSFormCurrencyModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormCurrencyCell : IMSFormTableViewCell

@property (strong, nonatomic) UITextField *textField; /**< <#property#> */

@property (strong, nonatomic) IMSFormCurrencyModel *model; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
