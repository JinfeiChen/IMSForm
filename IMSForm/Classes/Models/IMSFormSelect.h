//
//  IMSFormSelect.h
//  IMSForm
//  单选/多选数据对象
//
//  Created by cjf on 11/1/2021.
//

#import <IMSForm/IMSFormObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormSelect : IMSFormObject

//@property (copy, nonatomic) NSString *label; /**< <#property#> */
//@property (copy, nonatomic) NSString *value; /**< <#property#> */

@property (nonatomic, copy) NSString *title; /**< 分区标题 */

@property (copy, nonatomic) NSString *field; /**< <#property#> */
@property (strong, nonatomic) id param; /**< <#property#> */

//@property (assign, nonatomic, getter=isSelected) BOOL selected; /**< 选中状态 */
//@property (assign, nonatomic, getter=isEnable) BOOL enable; /**< 可用性 */

@property (assign, nonatomic, getter=isDeafult) BOOL isDefault; /**< <#property#> */

@property (strong, nonatomic) NSArray <IMSFormSelect *> *child; /**< <#property#> */



@end

NS_ASSUME_NONNULL_END
