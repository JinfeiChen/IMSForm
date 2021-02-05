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

//@property (copy, nonatomic) NSString *identifier; /**< 已声明在父类IMSFormObject中 */

@property (copy, nonatomic) IMSFormComponentType type; /**< 组件类型（字符串枚举） */

@property (copy, nonatomic) NSString *title; /**< 组件显示的标题, 为空时将显示 N/A */
@property (copy, nonatomic) NSString *customTitle; /**< 组件显示的自定义标题, default nil */
@property (copy, nonatomic) NSString *info; /**< 提示/说明文本 */
@property (copy, nonatomic) NSString *placeholder; /**< 占位文本 */

/**
 @value & @valueList 两个属性的使用：
 1.用于存储组件的默认值，常见于编辑数据时
 2.用于临时存储待提交到服务器的值（后面称为:关键值），通过 [IMSFormManager submit] 提交表单时，内部实现了把 ·关键值· 统一转移到 @param 属性中，方便外界读取和使用
 */
//@property (copy, nonatomic) NSString *value; /**< 组件的关键值, 字符串类型， 如在textfield这类组件中, e.g. "name" or "ID-123456789" - 已声明在父类IMSFormObject中 */
@property (strong, nonatomic) NSMutableArray *valueList; /**< 组件的关健值，数组类型，如在file/image/select/radio这类选择类的组件中 */

// SERVER
@property (copy, nonatomic) NSString *dbType; /**< 对应服务器自定义字段的类型 */
@property (copy, nonatomic) NSString *field; /**< 对应服务器字段 */
@property (strong, nonatomic) id param; /**< 对应服务器字段的值 */

// CELL
@property (copy, nonatomic) NSString *defaultSelectorString; /**< 默认组件点击事件的方法名，可在此目标方法中实现表单字段的相关业务逻辑 */
@property (copy, nonatomic) NSString *customSelectorString; /**< 自定义组件响应事件的方法名，可在此目标方法中实现表单字段的相关业务逻辑 */

// CPN
@property (strong, nonatomic) IMSFormCPNConfig *cpnConfig; /**< 组件配置, default: */
@property (strong, nonatomic) IMSFormCPNStyle *cpnStyle; /**< 组件样式, default: */
@property (strong, nonatomic) IMSFormCPNRule *cpnRule; /**< 组件校验, default: */

@end

NS_ASSUME_NONNULL_END
