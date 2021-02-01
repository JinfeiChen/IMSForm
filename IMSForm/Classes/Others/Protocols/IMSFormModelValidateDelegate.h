//
//  IMSFormModelValidateDelegate.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class IMSFormModel;
@protocol IMSFormModelValidateDelegate <NSObject>

@optional

- (BOOL)validateFormModel:(IMSFormModel *)formModel;
- (BOOL)validateFormModel:(IMSFormModel *)formModel keyPath:(NSString *)keyPath; // 预留校验方法

@end

NS_ASSUME_NONNULL_END
