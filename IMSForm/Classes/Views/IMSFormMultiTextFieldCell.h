//
//  IMSFormMultiTextFieldCell.h
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import <IMSForm/IMSFormTableViewCell.h>
#import <IMSForm/IMSFormMultiTextFieldModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormMultiTextFieldCell : IMSFormTableViewCell

@property (strong, nonatomic) UIButton *addButton; /**< <#property#> */
@property (strong, nonatomic) UITableView *listTableView; /**< <#property#> */

@property (strong, nonatomic) IMSFormMultiTextFieldModel *model; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
