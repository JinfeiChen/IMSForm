//
//  IMSFormLocalizeInputViewController.h
//  IMSForm
//
//  Created by cjf on 12/3/2021.
//

#import <IMSForm/IMSFormViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormLocalizeInputViewController : IMSFormViewController

@property (strong, nonatomic) NSArray *dataSource; /**< <#property#> */

@property (copy, nonatomic) void(^saveBlock)(NSArray *outputDataSource); /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
