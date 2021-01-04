//
//  IMSFormComponentRule.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <IMSForm/IMSFormObject.h>

#import <IMSForm/IMSFormMessage.h>
#import <IMSForm/IMSFormTrigger.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormComponentRule : IMSFormObject

@property (strong, nonatomic) IMSFormMessage *message; /**< 校验结果提示 */

@property (strong, nonatomic) NSArray <NSString *> * _Nullable validators; /**< 校验方法名列表 */

@property (copy, nonatomic) IMSFormTrigger trigger; /**< 触发方式 */

@end

NS_ASSUME_NONNULL_END
