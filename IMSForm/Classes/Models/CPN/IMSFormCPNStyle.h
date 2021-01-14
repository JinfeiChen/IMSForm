//
//  IMSFormCPNStyle.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormCPNStyle : IMSFormObject

+ (instancetype)defaultStyle;

@property (copy, nonatomic) IMSFormLayoutType layout; /**< 布局方向，横向/竖向 */

@property (copy, nonatomic) NSString *titleHexColor; /**< 标题颜色 e.g. 0xC0C0C0 */
@property (assign, nonatomic) CGFloat titleFontSize; /**< 标题字体大小， e.g. 16 */

@property (copy, nonatomic) NSString *infoHexColor; /**< 说明文字颜色， e.g. 0xC0C0C0 */
@property (assign, nonatomic) CGFloat infoFontSize; /**< 说明文字大小， e.g. 12 */

@property (copy, nonatomic) NSString *backgroundImageName; /**< 背景图片名称， e.g. picName */
@property (copy, nonatomic) NSString *backgroundHexColor; /**< 背景颜色， e.g. 0xC0C0C0 */

@property (copy, nonatomic) NSString *iconImageName; /**< 图标名称， e.g. iconName */

@property (assign, nonatomic) CGFloat borderWidth; /**< 边框大小， e.g. 1.0 */
@property (copy, nonatomic) NSString *borderHexColor; /**< 边框颜色， e.g. 0xC0C0C0 */

@property (assign, nonatomic) CGFloat spacing; /**< 组件内各元素间距， e.g. 10.0 */

@property (nonatomic) UIEdgeInsets contentInset; /**< 内边距， e.g. UIEdgeInsetsMake(12, 15, 12, 15) */

@end

NS_ASSUME_NONNULL_END
