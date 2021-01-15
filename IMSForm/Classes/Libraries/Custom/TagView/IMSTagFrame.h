//
//  IMSTagFrame.h
//  IMSForm
//
//  Created by cjf on 8/1/2021.
//

#import <IMSForm/IMSFormObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSTagFrame : IMSFormObject

/** 标签frame数组 */
@property (nonatomic, strong,readonly) NSMutableArray *tagsFrames;
/** 全部标签的高度 */
@property (nonatomic, assign,readonly) CGFloat tagsHeight;
/** 标签名字数组 */
@property (nonatomic, strong) NSArray *tagsArray;
/** 标签行间距 default is 10*/
@property (nonatomic, assign) CGFloat minimumLineSpacing;
/** 标签的间距 default is 10*/
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
/** 四周的那边距 默认为 top:0,letf:0,bottom:0,right:0*/
@property (nonatomic, assign) UIEdgeInsets contentInset;
/** 标签最小内边距 default is 10*/
@property (nonatomic, assign) CGFloat tagsMinPadding;
/**图片的宽度 默认为0 */
@property (nonatomic, assign) CGFloat imageViewWith;
// image 和title 的间距 默认为0。 现在的布局：title在右，image在左
@property (nonatomic, assign) CGFloat contentPadding;
// 字体大小 默认为12
@property (nonatomic, strong) UIFont *tagItemfontSize;
// 每个item 高度 默认20;
@property (nonatomic, assign) CGFloat tagItemHeight;
// 装载view的宽度  默认屏幕宽度
@property (nonatomic, assign) CGFloat tagSuperviewWidth;

@end

NS_ASSUME_NONNULL_END
