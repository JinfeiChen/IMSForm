//
//  IMSFormMessage.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <IMSForm/IMSFormObject.h>

#import <IMSForm/IMSFormMacros.h>
#import <IMSForm/IMSFormMessageType.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormMessageStyle : IMSFormObject

+ (instancetype)defaultStyle;

@property (assign, nonatomic) CGFloat titleFontSize; /**< <#property#> */
@property (assign, nonatomic) CGFloat titleFontWeight; /**< <#property#> */
@property (assign, nonatomic) int titleFontHexColor; /**< <#property#> */

@property (assign, nonatomic) CGFloat messageFontSize; /**< <#property#> */
@property (assign, nonatomic) CGFloat messageFontWeight; /**< <#property#> */
@property (assign, nonatomic) int messageFontHexColor; /**< <#property#> */

@property (assign, nonatomic) CGFloat borderWidth; /**< <#property#> */
@property (assign, nonatomic) int borderHexColor; /**< <#property#> */

@property (copy, nonatomic) NSString *backgroundImageName; /**< <#property#> */
@property (assign, nonatomic) int backgroundHexColor; /**< <#property#> */

@property (copy, nonatomic) NSString *iconName; /**< <#property#> */

@end

@interface IMSFormMessage : IMSFormObject

@property (copy, nonatomic) IMSFormMessageType type; /**< <#property#> */
@property (strong, nonatomic) IMSFormMessageStyle *style; /**< <#property#> */

@property (copy, nonatomic) NSString *title; /**< <#property#> */
@property (copy, nonatomic) NSString *message; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
