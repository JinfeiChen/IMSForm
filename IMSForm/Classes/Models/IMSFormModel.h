//
//  IMSFormModel.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <IMSForm/IMSFormObject.h>

#import <IMSForm/IMSFormCPNConfig.h>
#import <IMSForm/IMSFormCPNStyle.h>
#import <IMSForm/IMSFormCPNRule.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormModel : IMSFormObject

//@property (copy, nonatomic) NSString *identifier; /**< <#property#> */

@property (copy, nonatomic) IMSFormComponentType type; /**< 组件类型（字符串枚举） */

@property (copy, nonatomic) NSString *title; /**< 组件显示的标题 */
//@property (copy, nonatomic) NSString *value; /**< 组件显示的值, 字符串类型， 如在textfield这类组件中 */

@property (strong, nonatomic) NSMutableArray *valueList; /**< 组件显示的值，数组类型，如在file/image这类组件中 */
@property (copy, nonatomic) NSString *info; /**< 提示/说明文本 */
@property (copy, nonatomic) NSString *placeholder; /**< 占位文本 */

@property (copy, nonatomic) NSString *dbType; /**< 对应服务器自定义字段的类型 */
@property (copy, nonatomic) NSString *field; /**< 对应服务器字段 */
@property (strong, nonatomic) id param; /**< 对应服务器字段的值 */

@property (copy, nonatomic) NSString *defaultSelectorString; /**< 默认组件点击事件的方法名 */
@property (copy, nonatomic) NSString *customSelectorString; /**< 自定义组件响应事件的方法名 */

@property (strong, nonatomic) IMSFormCPNConfig *cpnConfig; /**< 组件配置, default: */
@property (strong, nonatomic) IMSFormCPNStyle *cpnStyle; /**< 组件样式, default: */
@property (strong, nonatomic) IMSFormCPNRule *cpnRule; /**< 组件校验, default: */

@end

NS_ASSUME_NONNULL_END
