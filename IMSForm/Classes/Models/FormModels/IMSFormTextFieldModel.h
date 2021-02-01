//
//  IMSFormTextFieldModel.h
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import <IMSForm/IMSFormModel.h>
#import <IMSForm/IMSFormTextFieldCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormTextFieldModel : IMSFormModel

@property (strong, nonatomic) IMSFormTextFieldCPNConfig *cpnConfig; /**< <#property#> */

@property (strong, nonatomic) IMSFormModel *prefixModel; /**< <#property#> */
@property (strong, nonatomic) IMSFormModel *suffixModel; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
