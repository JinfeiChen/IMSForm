//
//  CJFTableView.h
//  caricature
//
//  Created by cjf on 2019/8/23.
//

#import <UIKit/UIKit.h>
#import "UITableView+placeholder.h"
#import "CJFTableNoDataView.h"
#import "CJFTableErrorNetworkView.h"
//#import "UIScrollView+refresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJFTableView : UITableView

@property (strong, nonatomic) CJFTableNoDataView *noDataPlaceholderView; /**< <#property#> */
@property (strong, nonatomic) CJFTableErrorNetworkView *errorNetworkPlaceholderView; /**< <#property#> */

@end

NS_ASSUME_NONNULL_END
