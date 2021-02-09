//
//  IMSFormSliderModel.h
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import <IMSForm/IMSFormModel.h>
#import <IMSForm/IMSFormSliderCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormSliderModel : IMSFormModel

// value 的值范围: 1 ~ 10

@property (strong, nonatomic) IMSFormSliderCPNConfig *cpnConfig; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
