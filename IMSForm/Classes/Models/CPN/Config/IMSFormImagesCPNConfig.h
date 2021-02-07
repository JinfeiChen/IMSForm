//
//  IMSFormImagesCPNConfig.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormImagesCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic) NSInteger maxImagesLimit; /**< 最大图片数量, default 20 */
@property (assign, nonatomic) NSInteger rowImages; /**< 每行显示图片数量, 为了显示效果，maxImagesLimit最好为rowImages的倍数 */

/**<
 搜索方法名，需要在外界实现具体
 方法格式：exampleUpload:exampleResultBlock:
 e.g.
 - (void)testUploadImages:(NSArray <UIImage *> *)photos completed:(void (^)(NSArray <NSString *>*))callback
 callback 的回传参数为 图片地址数组 e.g. ["http://www.baidu.com/image/1234.jpg",...]
 */
@property (copy, nonatomic) NSString *imageUploadSelectorString;

@end

NS_ASSUME_NONNULL_END
