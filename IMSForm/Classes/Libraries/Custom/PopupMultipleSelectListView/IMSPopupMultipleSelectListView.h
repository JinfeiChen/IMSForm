//
//  IMSPopupMultipleSelectListView.h
//  Raptor
//
//  Created by cjf on 22/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <IMSForm/IMSFormView.h>

#import <IMSForm/CJFTableView.h>
#import <IMSForm/IMSPopupMultipleSelectModel.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IMSPopupMultipleSelectListViewCellType) {
    IMSPopupMultipleSelectListViewCellType_Default, // system: 显示选项名称
    IMSPopupMultipleSelectListViewCellType_Custom // custom: 自定义显示，开发者需要实现 customTableView:cellForRowAtIndexPath:
};

@interface IMSPopupMultipleSelectListView : IMSFormView

- (void)showView;
- (void)hiddenView;

@property (nonatomic, assign, readonly) BOOL isGroup; // 是否以组的形式显示,默认为不是
@property (nonatomic, assign) NSInteger didSelectedCount;// 已经选择的数量

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, assign) NSInteger maxCount;//最大限制数量
@property (assign, nonatomic) IMSPopupMultipleSelectListViewCellType cellType; /**< <#property#> */

- (void)setDataArray:(NSArray *)dataArray type:(IMSPopupMultipleSelectListViewCellType)cellType selectedDataArray:(NSArray *)selectedDataArray;

@property (nonatomic, copy) void (^didSelectedBlock)(NSArray *selectedDataArray, IMSFormSelect *selectedModel, BOOL isAdd, NSString *tipString);

@property (copy, nonatomic) void (^didFinishedShowAndHideBlock)(BOOL isShow); /**< <#property#> */

// 在子类中实现此方法可实现model自定义，model需为IMSFormSelect子类
//- (NSString *)customClassStringOfTableViewCellModel;
// 在子类中实现此方法可实现cell自定义, model需为IMSFormSelect子类
//- (UITableViewCell *)customTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
