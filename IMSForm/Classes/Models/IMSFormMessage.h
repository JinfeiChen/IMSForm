//
//  IMSFormMessage.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <IMSForm/IMSFormObject.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IMSFormMessageType) {
    IMSFormMessageType_Info,
    IMSFormMessageType_Warning,
    IMSFormMessageType_Success,
    IMSFormMessageType_Error
};

@interface IMSFormMessageStyle : IMSFormObject

@property (assign, nonatomic) CGFloat titleFontSize; /**< <#property#> */
@property (assign, nonatomic) CGFloat titleFontWeight; /**< <#property#> */
@property (copy, nonatomic) NSString *titleFontHexColor; /**< <#property#> */

@property (assign, nonatomic) CGFloat messageFontSize; /**< <#property#> */
@property (assign, nonatomic) CGFloat messageFontWeight; /**< <#property#> */
@property (copy, nonatomic) NSString *messageFontHexColor; /**< <#property#> */

@property (assign, nonatomic) CGFloat borderWidth; /**< <#property#> */
@property (copy, nonatomic) NSString *borderHexColor; /**< <#property#> */

@property (copy, nonatomic) NSString *backgroundImageName; /**< <#property#> */
@property (copy, nonatomic) NSString *backgroundHexColor; /**< <#property#> */

@property (copy, nonatomic) NSString *iconName; /**< <#property#> */

@end

@interface IMSFormMessage : IMSFormObject

@property (assign, nonatomic) IMSFormMessageType type; /**< <#property#> */
@property (strong, nonatomic) IMSFormMessageStyle *style; /**< <#property#> */

@property (copy, nonatomic) NSString *title; /**< <#property#> */
@property (copy, nonatomic) NSString *message; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
