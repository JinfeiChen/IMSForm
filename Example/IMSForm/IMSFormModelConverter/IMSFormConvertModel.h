//
//  IMSFormConvertModel.h
//  test
//
//  Created by cjf on 20/1/2021.
//  Copyright © 2021 cjf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormConvertCPNConfig : NSObject



@end

@interface IMSFormConvertModel : NSObject

@property (copy, nonatomic) NSString *type; /**< <#property#> */

@property (copy, nonatomic) NSString *title; /**< <#property#> */
@property (copy, nonatomic) NSString *field; /**< <#property#> */
@property (assign, nonatomic) BOOL editable; /**< <#property#> */

@property (strong, nonatomic) IMSFormConvertCPNConfig *cpnConfig; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
