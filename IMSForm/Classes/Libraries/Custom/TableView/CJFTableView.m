//
//  CJFTableView.m
//  caricature
//
//  Created by cjf on 2019/8/23.
//

#import "CJFTableView.h"

@implementation CJFTableView

- (CJFTableNoDataView *)noDataPlaceholderView
{
    if (!_noDataPlaceholderView) {
        _noDataPlaceholderView = [CJFTableNoDataView nibView];
        _noDataPlaceholderView.title = @"No data";
        _noDataPlaceholderView.imageName = @"img_no_data";
    }
    return _noDataPlaceholderView;
}

- (CJFTableErrorNetworkView *)errorNetworkPlaceholderView
{
    if (!_errorNetworkPlaceholderView) {
        _errorNetworkPlaceholderView = [CJFTableErrorNetworkView nibView];
        _errorNetworkPlaceholderView.title = @"Network error";
        _errorNetworkPlaceholderView.btnTitle = @"Refresh";
        _errorNetworkPlaceholderView.imageName = @"img_network_error";
        _errorNetworkPlaceholderView.clickHandler = ^(UIButton * _Nonnull sender) {
//            @strongify(self);
//            [self.tableView.mj_header beginRefreshing];
        };
    }
    return _errorNetworkPlaceholderView;
}

@end
