//
//  IMSFormTableViewCell.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <UIKit/UIKit.h>

#import <Masonry/Masonry.h>

#import <IMSForm/IMSFormMacros.h>
#import <IMSForm/IMSFormModel.h>

#define kIMSFormDefaultHeight 40.0

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormTableViewCell : UITableViewCell

@property (strong, nonatomic) IMSFormModel *model; /**< <#property#> */

@property (strong, nonatomic) UILabel *titleLabel; /**< <#property#> */
@property (strong, nonatomic) UILabel *infoLabel; /**< <#property#> */

@property (strong, nonatomic) UIView *bodyView; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
