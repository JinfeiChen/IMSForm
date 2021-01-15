//
//  IMSFormModelValidator.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormObject.h>
#import <IMSForm/IMSFormModelValidateDelegate.h>
#import <IMSForm/IMSFormValidateManager.h>
#import <IMSForm/IMSFormMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormModelValidator : IMSFormObject <IMSFormModelValidateDelegate>

@property (copy, nonatomic) NSString *className; /**< 校验器对应的类名 */
@property (copy, nonatomic) NSString *selectorName; /**< 校验方法名 */

@property (strong, nonatomic) IMSFormMessage *success; /**< <#property#> */
@property (strong, nonatomic) IMSFormMessage *failure; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
