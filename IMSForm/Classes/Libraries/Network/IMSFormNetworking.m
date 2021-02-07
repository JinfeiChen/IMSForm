//
//  IMSFormNetworking.m
//  IMSForm
//
//  Created by cjf on 7/2/2021.
//

#import "IMSFormNetworking.h"

@interface IMSFormNetworking ()

@property (strong, nonatomic) NSMutableDictionary *headerField; /**< <#property#> */

@end

@implementation IMSFormNetworking

- (void)get:(NSString *)urlString
      param:(NSDictionary *)parameters
    success:(void (^)(id _Nullable))success
    failure:(void (^)(NSError *_Nonnull))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 20;
    //1、创建NSURLSession对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    //2、利用NSURLSession创建任务(task)
    urlString = [urlString stringByAppendingFormat:@"?%@", [self formatParameters:parameters]];
    NSURL *url = [NSURL URLWithString:urlString];
    //创建请求对象里面包含请求体
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";

    //指定请求体的类型:`application/json`，请求参数要先转为json
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    if (self.headerField && self.headerField.count > 0) {
        for (NSString *key in self.headerField.allKeys) {
            [request setValue:self.headerField[key] forHTTPHeaderField:key];
        }
    }
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (error && failure) {
            failure(error);
        }
        if (!error && success) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            success(responseDict);
        }
    }];
    //3、执行任务
    [task resume];
}

- (void)post:(NSString *)urlString
       param:(NSDictionary *)parameters
     success:(void (^)(id _Nullable))success
     failure:(void (^)(NSError *_Nonnull))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 20;
    //1、创建NSURLSession对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    //2、利用NSURLSession创建任务(task)
    NSURL *url = [NSURL URLWithString:urlString];
    //创建请求对象里面包含请求体
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    //指定请求体的类型:`application/json`，请求参数要先转为json
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *paramString = [self convertJSONWithDic:parameters];
//    NSString *paramString = [self formatParameters:parameters];

    request.HTTPBody = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    if (self.headerField && self.headerField.count > 0) {
        for (NSString *key in self.headerField.allKeys) {
            [request setValue:self.headerField[key] forHTTPHeaderField:key];
        }
    }
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (error && failure) {
            failure(error);
        }
        if (!error && success) {
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSDictionary *allHeaderFields = res.allHeaderFields;

//            NSLog(@"请求地址：%@", response.URL.absoluteString);
//            if ([response.URL.absoluteString containsString:@"login"] == NO) {
//                NSLog(@"302");
//            }
//
//            if ([allHeaderFields.allKeys containsObject:@"Content-Length"]) {
//                NSNumber *lengthObj = [allHeaderFields objectForKey:@"Content-Length"];
//                //fileLength = [lengthObj integerValue];
//            }

//            NSLog(@"allHeaderFields is %@", allHeaderFields);

            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            success(responseDict);
        }
    }];
    //3、执行任务
    [task resume];
}

//实现大文件下载，但不支持断点下载
- (void)download:(NSString *)urlString
         success:(void (^)(id _Nullable))success
         failure:(void (^)(NSError *_Nonnull))failure
{
    // 1.创建url
    // 一些特殊字符编码
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    // 2.创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3.创建会话，采用苹果提供全局的共享session
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    // 4.创建任务
    NSURLSessionDownloadTask *downloadTask = [sharedSession downloadTaskWithRequest:request completionHandler:^(NSURL *_Nullable location, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (error == nil) {
            if (success) {
                success(@{ @"location": location.path });
            }
            // location:下载任务完成之后,文件存储的位置，这个路径默认是在tmp文件夹下!
            // 只会临时保存，因此需要将其另存
            NSLog(@"location:%@", location.path);
            // 采用模拟器测试，为了方便将其下载到Mac桌面
            // NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            //            NSString *filePath = @"/Users/chenjinfei/Desktop/test.mp3";
            //            NSError *fileError;
            //            [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:filePath error:&fileError];
            //            if (fileError == nil) {
            //                NSLog(@"file save success");
            //            }
            //            else {
            //                NSLog(@"file save error: %@",fileError);
            //            }
        } else {
            if (failure) {
                failure(error);
            }
        }
    }];
    // 5.开启任务
    [downloadTask resume];
}

- (void)formDataUpload:(NSString *)urlString
                 param:(NSData *)data
               success:(void (^)(id _Nullable))success
               failure:(void (^)(NSError *_Nonnull))failure
{
    // 1.创建url  采用Apache本地服务器
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    // 2.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 文件上传使用post
    request.HTTPMethod = @"POST";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"0xKhTmLbOuNdArY"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = data;
    if (self.headerField && self.headerField.count > 0) {
        for (NSString *key in self.headerField.allKeys) {
            [request setValue:self.headerField[key] forHTTPHeaderField:key];
        }
    }
    // 根据需要是否提供，非必须,如果不提供，session会自动计算
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    // 4.1 使用dataTask
    NSURLSessionDataTask *uploadTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (error == nil && success) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            success(responseDict);
        }
        if (error && failure) {
            failure(error);
        }
    }];
    // 5.执行任务
    [uploadTask resume];
}

- (void)binaryUpload:(NSString *)urlString
               param:(NSData *)data
             success:(void (^)(id _Nullable))success
             failure:(void (^)(NSError *_Nonnull))failure
{
    // 1.创建url
    // urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    // 2.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 文件上传使用post
    request.HTTPMethod = @"POST";
    // 3.创建NSURLSession对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.开始上传   request的body data将被忽略，而由fromData提供
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (error == nil && success) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            success(responseDict);
        }
        if (error && failure) {
            failure(error);
        }
    }];
    // 5.执行任务
    [uploadTask resume];
}

#pragma mark - Public Method - Tools

// filePath:要上传的文件路径   formName：表单控件名称  reName：上传后文件名
// 拼接表单，大小受MAX_FILE_SIZE限制(2MB)  FilePath:要上传的本地文件路径  formName:表单控件名称，应于服务器一致
- (NSData *)getHttpBodyWithFilePath:(NSString *)filePath
                           formName:(NSString *)formName
                             reName:(NSString *)reName
{
    NSMutableData *data = [NSMutableData data];
    NSURLResponse *response = [self getLocalFileResponse:filePath];
    // 文件类型：MIMEType  文件的大小：expectedContentLength  文件名字：suggestedFilename
    NSString *fileType = response.MIMEType;
    // 如果没有传入上传后文件名称,采用本地文件名!
    if (reName == nil) {
        reName = response.suggestedFilename;
    }
    // 表单拼接
    NSMutableString *headerStrM = [NSMutableString string];
    [headerStrM appendFormat:@"--%@\r\n", @"boundary"];
    // name：表单控件名称  filename：上传文件名
    [headerStrM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", formName, reName];
    [headerStrM appendFormat:@"Content-Type: %@\r\n\r\n", fileType];
    [data appendData:[headerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    // 文件内容
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [data appendData:fileData];
    NSMutableString *footerStrM = [NSMutableString stringWithFormat:@"\r\n--%@--\r\n", @"boundary"];
    [data appendData:[footerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    return data;
}

#pragma mark - Private Method

//字典转JSON
- (NSString *)convertJSONWithDic:(NSDictionary *)dic
{
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        return @"字典转JSON出错";
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)formatParameters:(NSDictionary *)parameters
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    for (NSString *key in parameters) {
        [resultString appendFormat:@"&%@=%@", key, [parameters valueForKey:key]];
    }
    return [resultString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
}

// 获取响应，主要是文件类型和文件名
- (NSURLResponse *)getLocalFileResponse:(NSString *)urlString
{
    // 本地文件请求
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL fileURLWithPath:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __block NSURLResponse *localResponse = nil;
    // 使用信号量实现NSURLSession同步请求
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        localResponse = response;
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return localResponse;
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    if (!_headerField) {
        _headerField = [NSMutableDictionary dictionary];
    }
    [_headerField setValue:value forKey:field];
}

@end
