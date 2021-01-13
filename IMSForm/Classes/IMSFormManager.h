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

#import <IMSForm/IMSPopupSingleSelectListView.h>
#import <IMSForm/IMSPopupMultipleSelectListView.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMSFormManagerDelegate <NSObject>

@optional

- (IMSPopupSingleSelectListView *)customSingleSelectListViewWithFormModel:(IMSFormModel *)formModel; // 自定义单选列表视图
- (IMSPopupMultipleSelectListView *)customMultipleSelectListViewWithFormModel:(IMSFormModel *)formModel; // 自定义多选列表视图

@end

@interface IMSFormManager : IMSFormObject

@property (weak, nonatomic) id<IMSFormManagerDelegate> delegate; /**< <#property#> */

@property (strong, nonatomic) UITableView *tableView; /**< <#property#> */
@property (strong, nonatomic) NSArray <IMSFormModel *> *dataSource; /**< <#property#> */

- (instancetype)initWithTableView:(UITableView *)tableView JSON:(NSString *)jsonName;

- (void)submit:(void(^)(BOOL isPass))validateCompleted;

@end

NS_ASSUME_NONNULL_END
