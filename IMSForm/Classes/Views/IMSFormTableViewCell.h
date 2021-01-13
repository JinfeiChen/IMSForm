//
//  IMSFormTableViewCell.h
//  Pods
//  自定义基类
//
//  Created by cjf on 31/12/2020.
//

#import <UIKit/UIKit.h>

#import <Masonry/Masonry.h>

#import <YYModel/YYModel.h>
#import <YYText/YYLabel.h>
#import <YYText/NSAttributedString+YYText.h>
#import <YYText/YYTextView.h>
#import <YYWebImage/YYWebImage.h>

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

/**
 设置数据
 
 @param model 数据模型
 @param form 表单管理对象
 @@return void
 */
- (void)setModel:(IMSFormModel * _Nonnull)model form:(IMSFormManager *)form;

/**
 设置组件标题
 
 @param title 标题
 @param required 是否必填
 @@return void
 */
- (void)setTitle:(NSString *)title required:(BOOL)required;

// 根据输入类型获取键盘类型
- (UIKeyboardType)keyboardWithTextType:(IMSFormTextType)textType;

// 校验数据
- (void)validate;

@end

NS_ASSUME_NONNULL_END
