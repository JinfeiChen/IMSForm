//
//  IMSFilePicker.m
//  IMSForm
//
//  Created by cjf on 7/1/2021.
//

#import "IMSFilePicker.h"

@interface IMSFilePicker () <UIDocumentPickerDelegate>

@property (nonatomic, strong) UIDocumentPickerViewController *documentPickerVC;

@end

@implementation IMSFilePicker

#pragma mark - Public Methods

- (void)presentDocumentPicker
{
    [self presentDocumentPickerOn:[[self keyWindow] rootViewController]];
}

- (void)presentDocumentPickerOn:(UIViewController *)viewController
{
    if (!viewController || ![viewController isKindOfClass:[UIViewController class]]) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [viewController presentViewController:self.documentPickerVC animated:YES completion:nil];
    });
}

#pragma mark - 下载文件
/// http://jadinec-test.oss-accelerate.aliyuncs.com/excelFile/a5f23e130d5e4dd7adda942c45207927.pdf
- (void)downLoadWithFilePath:(NSString *)filePath
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 11) {
        NSLog(@"下载文件要求手机系统版本在11.0以上");
        return;
    }
    /**
    /// 保存网络文件到沙盒一
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:filePath]];
    NSData *fileData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    NSString *temp = NSTemporaryDirectory();
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fullPath = [self getNativeFilePath:[filePath componentsSeparatedByString:@"/"].lastObject];
    BOOL downResult = [fm createFileAtPath:fullPath contents:fileData attributes:nil];
    */
    /// 保存网络文件到沙盒二
    NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
    NSString *fullPath = [self getNativeFilePath:[filePath componentsSeparatedByString:@"/"].lastObject];
    BOOL downResult = [fileData writeToFile:fullPath atomically:YES];

    if (downResult) {
        UIDocumentPickerViewController *documentPickerVC = [[UIDocumentPickerViewController alloc] initWithURL:[NSURL fileURLWithPath:fullPath] inMode:UIDocumentPickerModeExportToService];
        // 设置代理
        documentPickerVC.delegate = self;
        // 设置模态弹出方式
        documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet;
        [[[self keyWindow] rootViewController] presentViewController:documentPickerVC animated:YES completion:nil];
    }
}

// 获得文件沙盒地址
- (NSString *)getNativeFilePath:(NSString *)fileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *munu = [NSString stringWithFormat:@"%@/%@", @"downLoads", fileName];
    NSString *filePath = [path stringByAppendingPathComponent:munu];
    // 判断是否存在,不存在则创建
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL isDir = NO;
    NSMutableArray *theArr = [[filePath componentsSeparatedByString:@"/"] mutableCopy];
    [theArr removeLastObject];
    NSString *thePath = [theArr componentsJoinedByString:@"/"];
    BOOL existed = [fileManager fileExistsAtPath:thePath isDirectory:&isDir];
    if (!(isDir == YES && existed == YES) ) {  // 如果文件夹不存在
        [fileManager createDirectoryAtPath:thePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls
{
    // 获取授权
    BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileUrlAuthozied) {
        // 通过文件协调工具来得到新的文件地址，以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;

        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
            // 读取文件
            NSString *fileName = [newURL lastPathComponent];
            NSError *error = nil;
            NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
            if (error) {
                // 读取出错
            } else {
                // 上传
//                NSLog(@"fileName : %@", fileName);
                // [self uploadingWithFileData:fileData fileName:fileName fileURL:newURL];
            }
            if (self.documentPickerFinishedBlock) {
                self.documentPickerFinishedBlock(fileData, newURL, fileName, error);
            }
            [controller dismissViewControllerAnimated:YES completion:NULL];
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        // 授权失败
        NSError *error = [NSError errorWithDomain:NSNetServicesErrorDomain code:-1000 userInfo:@{
            NSLocalizedDescriptionKey: @"Authorization failed"
        }];
        if (self.documentPickerFinishedBlock) {
            self.documentPickerFinishedBlock(nil, nil, nil, error);
        }
    }
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    if (self.documentPickerCancelledBlock) {
        self.documentPickerCancelledBlock();
    }
}

#pragma mark - Getters

- (UIWindow *)keyWindow
{
    return [UIApplication sharedApplication].delegate.window ? : [UIApplication sharedApplication].windows.firstObject;
}

/**
 初始化 UIDocumentPickerViewController

 @param allowedUTIs 支持的文件类型数组
     "public.content",
     "public.text",
     "public.source-code",
     "public.image",
     "public.audiovisual-content",
     "com.adobe.pdf",
     "com.apple.keynote.key",
     "com.microsoft.word.doc",
     "com.microsoft.excel.xls",
     "com.microsoft.powerpoint.ppt"
 @param mode 支持的共享模式
 */
- (UIDocumentPickerViewController *)documentPickerVC
{
    if (!_documentPickerVC) {
        NSArray *types = @[
            @"public.content",
            @"public.text",
            @"public.source-code",
            @"public.image",
            @"public.audiovisual-content",
            @"com.adobe.pdf",
            @"com.apple.keynote.key",
            @"com.microsoft.word.doc",
            @"com.microsoft.excel.xls",
            @"com.microsoft.powerpoint.ppt"
        ];
        _documentPickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
        // 设置代理
        _documentPickerVC.delegate = self;
        // 设置模态弹出方式
        _documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return _documentPickerVC;
}

@end
