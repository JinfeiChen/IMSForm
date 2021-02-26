//
//  IMSPopupSingleSelectListView.h
//  Raptor
//
//  Created by cjf on 18/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <IMSForm/IMSFormView.h>

#import <IMSForm/CJFTableView.h>
#import <IMSForm/IMSPopupSingleSelectDefaultTableViewCell.h>
#import <IMSForm/IMSPopupSingleSelectContactTableViewCell.h>
#import <IMSForm/IMSPopupSingleSelectLocationTableViewCell.h>

typedef NS_ENUM(NSUInteger, IMSPopupSingleSelectListViewCellType) {
    IMSPopupSingleSelectListViewCellType_Default = 0, // system: 显示选项名称
    IMSPopupSingleSelectListViewCellType_Contact, // system: 显示联系人信息
    IMSPopupSingleSelectListViewCellType_Location, // system: 显示地址信息
    IMSPopupSingleSelectListViewCellType_Custom // custom: 自定义显示，开发者需要实现 customTableView:cellForRowAtIndexPath:
};

NS_ASSUME_NONNULL_BEGIN

@interface IMSPopupSingleSelectListView : IMSFormView

@property (nonatomic, strong) CJFTableView *mainTableView;
@property (strong, nonatomic) NSArray <IMSFormSelect *> *dataArray; /**< <#property#> */
@property (assign, nonatomic) IMSPopupSingleSelectListViewCellType cellType; /**< <#property#> */

- (void)showView;
- (void)hiddenView;

- (void)setDataArray:(NSArray *)dataArray type:(IMSPopupSingleSelectListViewCellType)type;

@property (nonatomic, copy) void (^didSelectedBlock)(NSArray *dataArray, IMSFormSelect *selectedModel);
@property (copy, nonatomic) void (^didFinishedShowAndHideBlock)(BOOL isShow); /**< <#property#> */

// 在子类中实现此方法可实现cell自定义, model则需实现IMSFormSelect子类
//- (UITableViewCell *)customTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
