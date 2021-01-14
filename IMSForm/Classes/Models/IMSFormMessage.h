//
//  IMSFormMessage.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <IMSForm/IMSFormObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormMessageStyle : IMSFormObject

+ (instancetype)defaultStyle;

@property (assign, nonatomic) CGFloat titleFontSize; /**< 标题字体大小 */
@property (copy, nonatomic) NSString *titleFontHexColor; /**< 标题字体颜色 */

@property (assign, nonatomic) CGFloat messageFontSize; /**< 消息字体大小 */
@property (copy, nonatomic) NSString *messageFontHexColor; /**< 消息字体颜色 */

@property (assign, nonatomic) CGFloat borderWidth; /**< 边框大小 */
@property (copy, nonatomic) NSString *borderHexColor; /**< 边框颜色 */

@property (copy, nonatomic) NSString *backgroundImageName; /**< 背景图片名称 */
@property (copy, nonatomic) NSString *backgroundHexColor; /**< 背景颜色 */

@property (copy, nonatomic) NSString *iconName; /**< 图标名称 */

@end

@interface IMSFormMessage : IMSFormObject

@property (copy, nonatomic) IMSFormMessageType type; /**< 消息类型 */
@property (strong, nonatomic) IMSFormMessageStyle *style; /**< 样式 */

@property (copy, nonatomic) NSString *title; /**< 消息标题 */
@property (copy, nonatomic) NSString *message; /**< 消息内容 */

@end

NS_ASSUME_NONNULL_END
