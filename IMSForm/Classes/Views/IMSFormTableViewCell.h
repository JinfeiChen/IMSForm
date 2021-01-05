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
#import <IMSForm/NSString+Extension.h>

#define kIMSFormDefaultHeight 40.0

NS_ASSUME_NONNULL_BEGIN

@class IMSFormManager;
@interface IMSFormTableViewCell : UITableViewCell

@property (strong, nonatomic, readonly) IMSFormModel *model; /**< <#property#> */
@property (strong, nonatomic) IMSFormManager *form; /**< <#property#> */

@property (strong, nonatomic) UILabel *titleLabel; /**< <#property#> */
@property (strong, nonatomic) UILabel *infoLabel; /**< <#property#> */

@property (strong, nonatomic) UIView *bodyView; /**< <#property#> */

@property (copy, nonatomic) void(^didUpdateFormModelBlock)(IMSFormTableViewCell *cell, IMSFormModel *model, id _Nullable reservedObj); /**< 默认数据源更新事件， 开发者需自行更新UITableView的数据源，按需执行UITableView的reloadData， reservedObj 预留参数 */
@property (copy, nonatomic) void(^customDidSelectedBlock)(IMSFormTableViewCell *cell, IMSFormModel *model, id _Nullable reservedObj); /**< 自定义点击事件， reservedObj 预留参数 */

- (void)setModel:(IMSFormModel * _Nonnull)model form:(IMSFormManager *)form;
- (void)setTitle:(NSString *)title required:(BOOL)required;

- (UIKeyboardType)keyboardWithTextType:(IMSFormTextType)textType;

@end

NS_ASSUME_NONNULL_END
