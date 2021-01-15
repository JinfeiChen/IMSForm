//
//  IMSFormTextFieldCell.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <IMSForm/IMSFormTableViewCell.h>
#import <IMSForm/IMSFormTextFieldModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormTextFieldCell : IMSFormTableViewCell

@property (strong, nonatomic) UITextField *textField; /**< <#property#> */

@property (strong, nonatomic) IMSFormTextFieldModel *model; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
