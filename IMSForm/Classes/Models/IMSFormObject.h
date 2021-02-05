//
//  IMSFormObject.h
//  Pods
//  自定义基类
//
//  Created by cjf on 30/12/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormObject : NSObject

@property (copy, nonatomic) NSString *identifier; /**< 唯一标识 */

@property (assign, nonatomic, getter=isEnable) BOOL enable; /**< 可用性 */
@property (assign, nonatomic, getter=isClearable) BOOL clearable; /**< 是否可清除 */
@property (assign, nonatomic, getter=isEditable) BOOL editable; /**< 是否可编辑 */
@property (assign, nonatomic, getter=isVisible) BOOL visible; /**< 是否可见 */
@property (assign, nonatomic, getter=isRequired) BOOL required; /**< 是否必需 */
@property (assign, nonatomic, getter=isSelected) BOOL selected; /**< 是否为选中状态 */

@property (copy, nonatomic) NSString *label; /**< 用于组件数据显示, e.g. 用户信息表中 name */
@property (copy, nonatomic) NSString *customLabel; /**< 用于组件自定义数据显示, e.g. 用户信息表中 name 的自定义显示 customName */

@property (copy, nonatomic) NSString *value; /**< 用于数据存储, e.g. 用户信息表中 name 的值 userId */

@end

NS_ASSUME_NONNULL_END
