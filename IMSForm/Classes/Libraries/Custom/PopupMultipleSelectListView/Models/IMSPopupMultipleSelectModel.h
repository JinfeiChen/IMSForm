//
//  IMSPopupMultipleSelectModel.h
//  Raptor
//
//  Created by cjf on 22/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <IMSForm/IMSFormObject.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IMSPopupMultipleSelectTableViewCellType) {
    IMSPopupMultipleSelectTableViewCellType_singleSelected = 0, //单选类型
    IMSPopupMultipleSelectTableViewCellType_manySelected, //多选类型
    IMSPopupMultipleSelectTableViewCellType_inputSearchReslut, //一个输入类型，有搜索结果列表的显示
};

@interface IMSPopupMultipleSelectModel : IMSFormObject

@property (nonatomic, assign) BOOL noSelect; // yes:不允许选择
@property (nonatomic, assign) NSInteger buttonState; // 选择类型 0：未选中状态， 1：选中状态  2：高亮状态
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, strong) NSArray <IMSPopupMultipleSelectModel *> *childArray;

//标题
@property (nonatomic, copy) NSString *titleString;
//对应的右边tableView 显示的标识
@property (nonatomic, assign) IMSPopupMultipleSelectTableViewCellType classCellIdentifier;
//是否显示搜索结果的view 默认为No
@property (nonatomic, assign) BOOL isShowSearchListView;

@property (nonatomic, strong) NSMutableArray <IMSPopupMultipleSelectModel *> *dataSourceArrayM;

@end

NS_ASSUME_NONNULL_END
