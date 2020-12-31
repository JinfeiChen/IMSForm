//
//  IMSFormComponentStyle.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <IMSForm/IMSFormObject.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IMSFormComponentLayout) {
    IMSFormComponentLayout_Horizontal,
    IMSFormComponentLayout_Vertical // default.
};

@interface IMSFormComponentStyle : IMSFormObject

+ (instancetype)defaultStyle;

@property (assign, nonatomic) IMSFormComponentLayout layout; /**< 布局方向，横向/竖向 */

@property (assign, nonatomic) int titleHexColor; /**< e.g. 0xC0C0C0 */
@property (assign, nonatomic) CGFloat titleFontSize; /**< <#property#> */

@property (assign, nonatomic) int infoHexColor; /**< <#property#> */
@property (assign, nonatomic) CGFloat infoFontSize; /**< <#property#> */

@property (copy, nonatomic) NSString *backgroundImageName; /**< <#property#> */
@property (assign, nonatomic) int backgroundHexColor; /**< <#property#> */

@property (copy, nonatomic) NSString *iconImageName; /**< <#property#> */

@property (assign, nonatomic) CGFloat borderWidth; /**< <#property#> */
@property (assign, nonatomic) CGFloat borderWeight; /**< <#property#> */
@property (assign, nonatomic) int borderHexColor; /**< <#property#> */

@property (assign, nonatomic) CGFloat spacing; /**< <#property#> */

@property (nonatomic) UIEdgeInsets contentInset; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
