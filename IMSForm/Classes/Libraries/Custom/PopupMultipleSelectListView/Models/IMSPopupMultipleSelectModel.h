//
//  IMSPopupMultipleSelectModel.h
//  Raptor
//
//  Created by cjf on 22/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <IMSForm/IMSFormSelect.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IMSPopupMultipleSelectTableViewCellType) {
    IMSPopupMultipleSelectTableViewCellType_singleSelected = 0, //单选类型
    IMSPopupMultipleSelectTableViewCellType_manySelected, //多选类型
    IMSPopupMultipleSelectTableViewCellType_inputSearchReslut, //一个输入类型，有搜索结果列表的显示
};

@interface IMSPopupMultipleSelectModel : IMSFormSelect

@end

NS_ASSUME_NONNULL_END
