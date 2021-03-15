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

@property (nonatomic, copy) NSString *groupTitle; /**< 分区标题 */

@property (copy, nonatomic) NSString *field; /**< <#property#> */
@property (strong, nonatomic) id param; /**< <#property#>   */

@property (assign, nonatomic, getter=isDeafult) BOOL isDefault; /**< <#property#> */

@property (strong, nonatomic) NSArray <IMSFormSelect *> *child; /**< <#property#> */



@end

NS_ASSUME_NONNULL_END
