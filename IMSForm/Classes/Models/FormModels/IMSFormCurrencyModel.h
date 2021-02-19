//
//  IMSFormCurrencyModel.h
//  IMSForm
//
//  Created by cjf on 22/1/2021.
//

#import <IMSForm/IMSForm.h>
#import <IMSForm/IMSFormCurrencyCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormCurrencyModel : IMSFormModel

@property (copy, nonatomic) NSString *price_identifier; /**< <#property#> */
@property (copy, nonatomic) NSString *currency_identifier; /**< <#property#> */

@property (strong, nonatomic) IMSFormCurrencyCPNConfig *cpnConfig; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
