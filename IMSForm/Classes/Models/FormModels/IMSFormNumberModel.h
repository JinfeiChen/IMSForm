//
//  IMSFormNumberModel.h
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import <IMSForm/IMSFormModel.h>
#import <IMSForm/IMSFormNumberCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormNumberModel : IMSFormModel

@property (strong, nonatomic) IMSFormNumberCPNConfig *cpnConfig; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
