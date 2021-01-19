//
//  IMSFormSelectView.h
//  IMSForm
//
//  Created by cjf on 18/1/2021.
//

#import <IMSForm/IMSFormView.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormSelectView : IMSFormView

@property (strong, nonatomic) UILabel *textLabel; /**< <#property#> */
@property (assign, nonatomic, getter=isSelected) BOOL selected; /**< <#property#> */

@property (copy, nonatomic) void(^didSelectBlock)(id obj); /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
