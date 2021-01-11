//
//  IMSFormSelect.h
//  IMSForm
//  单选/多选数据对象
//
//  Created by cjf on 11/1/2021.
//

#import <IMSForm/IMSForm.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormSelect : IMSFormObject

@property (copy, nonatomic) NSString *value; /**< <#property#> */
@property (strong, nonatomic) id param; /**< <#property#> */
@property (assign, nonatomic, getter=isSelected) BOOL selected; /**< <#property#> */

@property (strong, nonatomic) NSArray <IMSFormSelect *> *child; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
