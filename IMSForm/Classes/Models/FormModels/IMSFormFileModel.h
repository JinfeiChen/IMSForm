//
//  IMSFormFileModel.h
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import <IMSForm/IMSFormModel.h>
#import <IMSForm/IMSFormFileCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormFileModel : IMSFormModel

@property (strong, nonatomic) IMSFormFileCPNConfig *cpnConfig; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
