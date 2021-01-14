//
//  IMSFormRangeCell.h
//  IMSForm
//
//  Created by cjf on 6/1/2021.
//

#import <IMSForm/IMSFormTableViewCell.h>
#import <IMSForm/IMSFormRangeModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormRangeCell : IMSFormTableViewCell

@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UITextField *minTextField;
@property (nonatomic, strong) UITextField *maxTextField;

@property (strong, nonatomic) IMSFormRangeModel *model; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
