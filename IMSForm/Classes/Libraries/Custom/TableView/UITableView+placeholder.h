//
//  UITableView+placeholder.h
//  caricature
//
//  Created by cjf on 2019/8/26.
//

#import <UIKit/UIKit.h>

@protocol CJFTableViewPlaceholderDelegate <UITableViewDelegate>

@optional
- (UIView * _Nullable)placeholderView;

@end

typedef NS_ENUM(NSUInteger, CJFTableViewPlaceholderStyle) {
    CJFTableViewPlaceholderStyle_Default = 0,
    CJFTableViewPlaceholderStyle_NoData,
    CJFTableViewPlaceholderStyle_ErrorNetWork,
};

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (placeholder)

@property (assign, nonatomic) CJFTableViewPlaceholderStyle placeholderStyle; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
