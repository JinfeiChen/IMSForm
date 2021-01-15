//
//  IMSFormNumberCell.h
//  IMSForm
//
//  Created by cjf on 6/1/2021.
//

#import <IMSForm/IMSFormTableViewCell.h>
#import <IMSForm/IMSFormNumberModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormNumberCell : IMSFormTableViewCell

@property (nonatomic, strong) UIButton *increaseButton;
@property (nonatomic, strong) UIButton *decreaseButton;
@property (strong, nonatomic) UITextField *textField; /**< <#property#> */

@property (strong, nonatomic) IMSFormNumberModel *model; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
