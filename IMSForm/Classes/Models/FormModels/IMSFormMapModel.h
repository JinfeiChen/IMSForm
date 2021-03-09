//
//  IMSFormMapModel.h
//  IMSForm
//  [配置]:
//  1.添加 MapKit & CoreLocation 库
//  2.Info.plist 添加 NSLocationUsageDescription & NSLocationWhenInUseUsageDescription & NSLocationAlwaysUsageDescription & NSLocationAlwaysAndWhenInUseUsageDescription
//
//  Created by cjf on 26/2/2021.
//

#import <IMSForm/IMSFormModel.h>
#import <IMSForm/IMSFormMapCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormMapModel : IMSFormModel

@property (strong, nonatomic) IMSFormMapCPNConfig *cpnConfig; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
