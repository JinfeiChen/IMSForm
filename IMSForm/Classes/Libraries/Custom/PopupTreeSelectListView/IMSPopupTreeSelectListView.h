//
//  IMSPopupTreeSelectListView.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/13.
//

#import <IMSForm/IMSForm.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSPopupTreeSelectListView : IMSFormView

- (void)showView;// 显示view
- (void)hiddenView;

@property (nonatomic, assign) NSInteger maxCount;//最大限制数量
@property (nonatomic, assign) NSInteger didSelectedCount;// 已经选择的数量
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) BOOL isMultiple;// 是否多项，默认多选
@property (nonatomic, copy) void (^didSelectedBlock)(id selectedModel, BOOL isAdd, NSString *tipString);
@property (copy, nonatomic) void (^didFinishedShowAndHideBlock)(BOOL isShow); /**< <#property#> */
@end

NS_ASSUME_NONNULL_END
