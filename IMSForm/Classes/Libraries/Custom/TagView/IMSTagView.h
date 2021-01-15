//
//  IMSTagView.h
//  IMSForm
//
//  Created by cjf on 8/1/2021.
//

#import <IMSForm/IMSFormView.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSTagViewUIModel : NSObject

@property (nonatomic, strong) NSString * _Nonnull text;
@property (nonatomic, strong) UIColor * _Nullable borderColor;
@property (nonatomic, assign) NSInteger borderWidth;
@property (nonatomic, strong) UIColor * _Nullable backgroudColor;
@property (nonatomic, strong) UIColor * _Nonnull textColor;
@property (nonatomic, assign) BOOL masksToBounds;
@property (nonatomic, assign) CGFloat cornerRadius;
@end

@class IMSTagView;
@protocol IMSTagViewDelegate <NSObject>

- (void)tagView:(IMSTagView *_Nullable)tagView didSelectAtIndex:(NSInteger)index;

@end

@interface IMSTagView : IMSFormView

// 数据源
@property (nonatomic, strong) NSArray <IMSTagViewUIModel *> *dataUIModelArray;

// 数据源
@property (nonatomic, strong) NSArray <NSString *>*dataArray;
// delete Image
@property (nonatomic, strong) UIImage * _Nullable deleteImage;
// image 和title 的间距 默认为0。 现在的布局：title在右，image在左
@property (nonatomic, assign) CGFloat contentPadding;
/** 标签行间距 default is 10*/
@property (nonatomic, assign) CGFloat minimumLineSpacing;
/** 标签的间距 default is 10*/
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
/** 四周的那边距 默认为 top:0,letf:0,bottom:0,right:0*/
@property (nonatomic, assign) UIEdgeInsets contentInset;
/** 标签最小左右内边距 default is 10*/
@property (nonatomic, assign) CGFloat tagsMinPadding;
// 字体大小 默认为12
@property (nonatomic, strong) UIFont *tagItemfontSize;
// 每个item 高度 默认20
@property (nonatomic, assign) CGFloat tagItemHeight;
// 装载view的宽度 默认为屏幕宽度
@property (nonatomic, assign) CGFloat tagSuperviewWidth;
// 装载view最小的高度 默认为0
@property (nonatomic, assign) CGFloat tagSuperviewMinHeight;

@property (nonatomic, weak) id<IMSTagViewDelegate> delegate;

@property (strong, nonatomic) UIColor *tintColor; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
