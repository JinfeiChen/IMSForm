//
//  IMSFormComponentStyle.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <IMSForm/IMSFormObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormComponentStyle : IMSFormObject

@property (copy, nonatomic) NSString *titleHexColor; /**< <#property#> */
@property (assign, nonatomic) CGFloat titleFontSize; /**< <#property#> */

@property (copy, nonatomic) NSString *infoHexColor; /**< <#property#> */
@property (assign, nonatomic) CGFloat infoFontSize; /**< <#property#> */

@property (copy, nonatomic) NSString *backgroundImageName; /**< <#property#> */
@property (copy, nonatomic) NSString *backgroundHexColor; /**< <#property#> */

@property (copy, nonatomic) NSString *iconImageName; /**< <#property#> */

@property (assign, nonatomic) CGFloat borderWidth; /**< <#property#> */
@property (assign, nonatomic) CGFloat borderWeight; /**< <#property#> */
@property (copy, nonatomic) NSString *borderHexColor; /**< <#property#> */

@property (assign, nonatomic) CGFloat spacing; /**< <#property#> */

@property (nonatomic) UIEdgeInsets contentInset; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
