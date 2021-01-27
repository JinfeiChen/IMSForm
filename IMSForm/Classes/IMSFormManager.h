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

//#import <IMSForm/IMSPopupSingleSelectListView.h>
//#import <IMSForm/IMSPopupMultipleSelectListView.h>
#import <IMSForm/IMSFormManagerUIDelegate.h>
#import <IMSForm/IMSFormManagerDataDelegate.h>

NS_ASSUME_NONNULL_BEGIN

//@protocol IMSFormManagerDelegate <NSObject>
//
//@optional
//
//- (IMSPopupSingleSelectListView *)customSingleSelectListViewWithFormModel:(IMSFormModel *)formModel; // 自定义单选列表视图
//- (IMSPopupMultipleSelectListView *)customMultipleSelectListViewWithFormModel:(IMSFormModel *)formModel; // 自定义多选列表视图
//- (void)testInputSearchWithFormModel:(IMSFormModel *)formModel completation:(void(^)(NSArray *dataArray))callback;
//
//@end

@interface IMSFormManager : IMSFormObject

//@property (weak, nonatomic) id<IMSFormManagerDelegate> delegate __attribute__((deprecated("Use -uiDelegate."))); /**< <#property#> */

@property (weak, nonatomic) id<IMSFormManagerUIDelegate> uiDelegate; /**< <#property#> */
@property (weak, nonatomic) id<IMSFormManagerDataDelegate> dataDelegate; /**< <#property#> */

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
