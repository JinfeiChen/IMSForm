//
//  IMSFormCPNConfig.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormCPNIOConfig : NSObject

@property (copy, nonatomic) NSString *type; /**< array/json/string/last */

@property (strong, nonatomic) NSArray <NSString *> *fields; /**< <#property#> */
@property (copy, nonatomic) NSString *jsonField; /**< type = json 时，存储值的key */
@property (copy, nonatomic) NSString *fieldPrice; /**< <#property#> */
@property (copy, nonatomic) NSString *fieldCurrency; /**< <#property#> */
@property (copy, nonatomic) NSString *fieldAddress; /**< <#property#> */
@property (copy, nonatomic) NSString *fieldLatitude; /**< <#property#> */
@property (copy, nonatomic) NSString *fieldLongitude; /**< <#property#> */

@property (copy, nonatomic) NSString *sep; /**< type = string 时，用于多个值的连接（分隔）符号 */

@end

@interface IMSFormCPNConfig : IMSFormObject

@property (strong, nonatomic) NSArray *dataSource; /**< <#property#> */

@property (strong, nonatomic) IMSFormCPNIOConfig *ioConfig; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
