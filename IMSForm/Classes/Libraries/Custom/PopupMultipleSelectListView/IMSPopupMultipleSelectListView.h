//
//  IMSPopupMultipleSelectListView.h
//  Raptor
//
//  Created by cjf on 22/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <IMSForm/IMSForm.h>

#import <IMSForm/IMSPopupMultipleSelectModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSPopupMultipleSelectListView : IMSFormView

- (void)showView;
- (void)hiddenView;

@property (nonatomic, assign) NSInteger maxCount;//最大限制数量
@property (nonatomic, assign) NSInteger didSelectedCount;// 已经选择的数量
@property (nonatomic, assign) BOOL isGroup; // 是否以组的形式显示,默认为不是
@property (nonatomic, copy) NSArray <IMSPopupMultipleSelectModel *> *dataArray;

@property (nonatomic, copy) void (^didSelectedBlock)(IMSPopupMultipleSelectModel *selectedModel, BOOL isAdd, NSString *tipString);

@property (nonatomic, copy) void (^refreshUI)(void);

@end

NS_ASSUME_NONNULL_END
