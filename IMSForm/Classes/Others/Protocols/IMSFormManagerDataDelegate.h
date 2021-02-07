//
//  IMSFormManagerDataDelegate.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMSFormManagerDataDelegate <NSObject>

@optional

- (void)IMSForm_UploadImages:(NSArray <UIImage *> *)photos completed:(void (^)(NSArray <NSString *>*))callback;
- (void)IMSForm_UploadFile:(NSDictionary *)fileData completed:(void (^)(NSArray <NSDictionary *> *))callback;

@end

NS_ASSUME_NONNULL_END
