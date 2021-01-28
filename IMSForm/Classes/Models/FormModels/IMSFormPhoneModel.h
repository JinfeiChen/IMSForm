//
//  IMSFormPhoneModel.h
//  IMSForm
//
//  Created by cjf on 28/1/2021.
//

#import <IMSForm/IMSFormModel.h>
#import <IMSForm/IMSFormPhoneCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormPhoneModel : IMSFormModel

@property (strong, nonatomic) IMSFormPhoneCPNConfig *cpnConfig; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
