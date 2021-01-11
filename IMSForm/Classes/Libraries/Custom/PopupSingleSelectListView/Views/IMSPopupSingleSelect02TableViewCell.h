//
//  IMSPopupSingleSelect02TableViewCell.h
//  Raptor
//
//  Created by cjf on 18/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <IMSForm/IMSPopupSingleSelectModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSPopupSingleSelect02TableViewCell : UITableViewCell

@property (nonatomic, strong) IMSPopupSingleSelectModel *dataModel;
@property (nonatomic, strong) IMSPopupSingleSelectModel *sourceCampaignModel;

@end

NS_ASSUME_NONNULL_END
