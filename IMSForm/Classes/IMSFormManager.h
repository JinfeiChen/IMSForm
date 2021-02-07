//
//  IMSFormManager.h
//  Pods
//
//  Created by cjf on 4/1/2021.
//

#import <IMSForm/IMSFormObject.h>

#import <IMSForm/IMSFormDataManager.h>
#import <IMSForm/IMSFormLocalizedManager.h>
#import <IMSForm/IMSFormTypeManager.h>
#import <IMSForm/IMSFormValidateManager.h>
#import <IMSForm/IMSFormUIManager.h>

#import <IMSForm/IMSFormManagerUIDelegate.h>
#import <IMSForm/IMSFormManagerDataDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormManager : IMSFormObject
/**<
 表单UI代理对象
 single/multiple select list view 组件的代理方法 自定义列表 在此对象中实现
 */
@property (weak, nonatomic) id<IMSFormManagerUIDelegate> uiDelegate;

/**<
 表单Data代理对象
 inputSearch/imageUpload/fileUpload 组件的代理方法 搜索/图片上传/文件上传 都在此对象中实现
 */
@property (weak, nonatomic) id<IMSFormManagerDataDelegate> dataDelegate;

@property (strong, nonatomic) UITableView *tableView; /**< <#property#> */
@property (strong, nonatomic) NSArray <IMSFormModel *> *dataSource; /**< 表单数据源 */

- (instancetype)initWithTableView:(UITableView *)tableView JSON:(NSString * _Nullable)jsonName;

/**
 提交表单
 
 @param validateCompleted 返回校验结果
 */
- (void)submit:(void(^)(NSError *error))validateCompleted;



@end

NS_ASSUME_NONNULL_END
