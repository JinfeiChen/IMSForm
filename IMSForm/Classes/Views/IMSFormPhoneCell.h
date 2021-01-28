//
//  IMSFormPhoneCell.h
//  IMSForm
//
//  Created by cjf on 28/1/2021.
//

#import <IMSForm/IMSForm.h>
#import <IMSForm/IMSFormPhoneModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormPhoneCell : IMSFormTableViewCell

@property (strong, nonatomic) UITextField *textField; /**< <#property#> */

@property (strong, nonatomic) IMSFormPhoneModel *model; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
