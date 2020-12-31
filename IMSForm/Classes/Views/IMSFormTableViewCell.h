//
//  IMSFormTableViewCell.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <UIKit/UIKit.h>

#import <IMSForm/IMSFormModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormTableViewCell : UITableViewCell

@property (strong, nonatomic) IMSFormModel *model; /**< <#property#> */

@property (strong, nonatomic) UILabel *titleLabel; /**< <#property#> */
@property (strong, nonatomic) UILabel *infoLabel; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
