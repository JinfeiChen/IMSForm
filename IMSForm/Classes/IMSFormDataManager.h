//
//  IMSFormDataManager.h
//  Pods
//
//  Created by cjf on 30/12/2020.
//

#import <IMSForm/IMSFormObject.h>

#import <IMSForm/IMSFormTypeManager.h>
#import <IMSForm/IMSFormUIManager.h>

#import <IMSForm/IMSFormModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormDataManager : IMSFormObject

+ (NSArray <IMSFormModel *> *)formDataArrayWithJson:(NSString *)jsonDataString;

@end

NS_ASSUME_NONNULL_END
