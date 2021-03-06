//
//  CJFTableErrorNetworkView.h
//  caricature
//
//  Created by cjf on 2019/8/26.
//

#import <UIKit/UIView.h>
#import <IMSForm/UIView+Extension.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJFTableErrorNetworkView : UIView

@property (copy, nonatomic) NSString *imageName; /**< <#property#> */
@property (copy, nonatomic) NSString *title; /**< <#property#> */
@property (copy, nonatomic) NSString *btnTitle; /**< <#property#> */

@property (copy, nonatomic) void(^clickHandler)(UIButton *sender); /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
