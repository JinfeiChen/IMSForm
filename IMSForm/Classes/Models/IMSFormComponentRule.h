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

@class IMSFormModel;
typedef BOOL(^IMSFormModelValidateBlock)(IMSFormModel * _Nullable model); 

@interface IMSFormComponentRule : IMSFormObject

@property (strong, nonatomic) IMSFormMessage *message; /**< 校验结果提示 */

@property (strong, nonatomic) NSArray <IMSFormModelValidateBlock> *validators; /**< 校验器列表 */

@property (copy, nonatomic) IMSFormTrigger trigger; /**< 触发方式 */

@end

NS_ASSUME_NONNULL_END
