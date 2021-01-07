//
//  IMSFilePicker.h
//  IMSForm
//
//  Created by cjf on 7/1/2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFilePicker : NSObject

@property (nonatomic, strong, readonly) UIDocumentPickerViewController *documentPickerVC;

// 打开手机文件，选择上传
- (void)presentDocumentPicker;
- (void)presentDocumentPickerOn:(UIViewController *)viewController;
// 下载文件，保存到手机文件
- (void)downLoadWithFilePath:(NSString *)filePath;

@property (copy, nonatomic) void(^documentPickerFinishedBlock)(NSData * _Nullable fileData, NSURL * _Nullable fileURL, NSString * _Nullable fileName, NSError * _Nullable error); /**< <#property#> */
@property (copy, nonatomic) void(^documentPickerCancelledBlock)(void); /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
