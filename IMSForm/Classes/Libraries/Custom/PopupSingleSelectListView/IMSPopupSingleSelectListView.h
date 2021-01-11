//
//  IMSPopupSingleSelectListView.h
//  Raptor
//
//  Created by cjf on 18/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <IMSForm/IMSForm.h>

#import <IMSForm/IMSPopupSingleSelect01TableViewCell.h>
#import <IMSForm/IMSPopupSingleSelect02TableViewCell.h>

typedef NS_ENUM(NSUInteger, IMSPopupSingleSelectListViewCellType) {
    IMSPopupSingleSelectListViewSystemCell = 0, //只显示名称
    IMSPopupSingleSelectListViewRelatedCell,
    IMSPopupSingleSelectListViewSourceCampaignCell,
};

NS_ASSUME_NONNULL_BEGIN

@interface IMSPopupSingleSelectListView : IMSFormView

- (void)showView;
- (void)hiddenView;

@property (nonatomic, assign) IMSPopupSingleSelectListViewCellType cellType;
@property (nonatomic, strong) NSArray <IMSPopupSingleSelectModel *> *dataArray;

@property (nonatomic, copy) void (^didSelectedBlock)(IMSPopupSingleSelectModel * selectedModel);
@property (nonatomic, copy) void (^refreshUI)(void);

@end

NS_ASSUME_NONNULL_END
