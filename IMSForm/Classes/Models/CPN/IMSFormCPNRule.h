//
//  IMSFormCPNRule.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormCPNRule : IMSFormObject

@property (strong, nonatomic) NSArray * _Nullable validators; /**< 校验器列表 */

@property (copy, nonatomic) IMSFormTrigger trigger; /**< 触发方式 */

@end

NS_ASSUME_NONNULL_END
