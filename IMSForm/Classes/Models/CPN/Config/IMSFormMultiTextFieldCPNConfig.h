//
//  IMSFormMultiTextFieldCPNConfig.h
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormMultiTextFieldCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic) NSInteger maxLimit; /**< max numbers limit of textfield */
@property (copy, nonatomic) NSString *addButtonTitle; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
