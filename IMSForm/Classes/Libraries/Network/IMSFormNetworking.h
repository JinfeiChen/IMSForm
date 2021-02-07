//
//  IMSFormNetworking.h
//  IMSForm
//
//  Created by cjf on 7/2/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormNetworking : NSObject

#pragma mark - Public Method - CJF HTTP

/**
 GET请求

 @param urlString 请求路径
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)get:(NSString *)urlString
      param:(NSDictionary *)parameters
    success:(void (^)(id _Nullable responseObject))success
    failure:(void (^)(NSError *_Nonnull error))failure;

/**
 POST请求

 @param urlString 请求路径
 @param parameters 参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)post:(NSString *)urlString
       param:(NSDictionary *)parameters
     success:(void (^)(id _Nullable responseObject))success
     failure:(void (^)(NSError *_Nonnull error))failure;

/**
 文件下载

 @param urlString 下载路径
 @param success 成功回调
 @param failure 失败回调
 */
- (void)download:(NSString *)urlString
         success:(void (^)(id _Nullable responseObject))success
         failure:(void (^)(NSError *_Nonnull error))failure;

/**
 文件上传 - 方式：拼接表单

 @param urlString 上传路径
 @param data 数据
 @param success 成功回调
 @param failure 失败回调
 */
- (void)formDataUpload:(NSString *)urlString
                 param:(NSData *)data
               success:(void (^)(id _Nullable responseObject))success
               failure:(void (^)(NSError *_Nonnull error))failure;

/**
 文件上传 - 方式：数据流

 @param urlString 上传路径
 @param data 数据
 @param success 成功回调
 @param failure 失败回调
 */
- (void)binaryUpload:(NSString *)urlString
               param:(NSData *)data
             success:(void (^)(id _Nullable responseObject))success
             failure:(void (^)(NSError *_Nonnull error))failure;

#pragma mark - Public Method - CJF TOOLS

/**
 文件转NSData - [可用于上传文件]
 注：拼接表单，大小受MAX_FILE_SIZE限制(2MB)  filePath:要上传的本地文件路径  formName:表单控件名称，应于服务器一致

 @param filePath 要上传的文件路径
 @param formName 表单控件名称
 @param reName 上传后文件名
 @return 数据
 */
- (NSData *)getHttpBodyWithFilePath:(NSString *)filePath
                           formName:(NSString *)formName
                             reName:(NSString *)reName;

- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(NSString *)field;

@end

NS_ASSUME_NONNULL_END
