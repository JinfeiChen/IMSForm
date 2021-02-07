//
//  IMSFormFileCPNConfig.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormFileCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic) NSInteger maxFilesLimit; /**< 最大文件数量, default 20 */

/**<
 搜索方法名，需要在外界实现具体
 方法格式：exampleUpload:exampleResultBlock:
 e.g.
 - (void)testUploadFile:(NSDictionary *)fileData completed:(void (^)(NSArray <NSDictionary *> *))callback
 callback 的回传参数为 文件信息字典数组 e.g. [{"name":"http://www.baidu.com/file/1234.pdf"},...]
 */
@property (copy, nonatomic) NSString *fileUploadSelectorString;

@end

NS_ASSUME_NONNULL_END
