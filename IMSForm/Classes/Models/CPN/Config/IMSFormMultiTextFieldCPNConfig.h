//
//  IMSFormMultiTextFieldCPNConfig.h
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

/**
 Example:
 
 "cpnConfig" : {
     "maxLimit" : 5,
     "addButtonTitle" : "Add Car Park",
     "prefixDataSource" : [
         {
             "label" : "China",
             "value" : "+86"
         },
         {
             "label" : "America",
             "value" : "+00",
             "selected" : 1
         },
         {
             "label" : "HongKong",
             "value" : "+852"
         }
     ],
     "suffixDataSource" : [
         {
             "label" : "China",
             "value" : "CNY"
         },
         {
             "label" : "America",
             "value" : "USD",
             "selected" : 1
         }
     ]
 }
 */

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormMultiTextFieldCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic) NSInteger maxLimit; /**< max numbers limit of textfield */
@property (copy, nonatomic) NSString *addButtonTitle; /**< <#property#> */

@property (strong, nonatomic) NSArray *prefixDataSource; /**< <#property#> */
@property (strong, nonatomic) NSArray *suffixDataSource; /**< <#property#> */

@property (copy, nonatomic) NSString *prefixCustomSelector; /**< <#property#> */
@property (copy, nonatomic) NSString *suffixCustomSelector; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
