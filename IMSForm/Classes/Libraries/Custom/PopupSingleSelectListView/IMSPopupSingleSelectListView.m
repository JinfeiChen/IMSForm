//
//  IMSPopupSingleSelectListView.m
//  Raptor
//
//  Created by cjf on 18/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupSingleSelectListView.h"
#import <IMSForm/IMSFormMacros.h>

@interface IMSPopupSingleSelectListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation IMSPopupSingleSelectListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, IMS_SCREEN_WIDTH, IMS_SCREEN_HEIGHT)]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        self.hidden = YES;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.mainTableView];
        [IMSAppWindow addSubview:self];
    }
    return self;
}

- (void)showView {
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.hidden = NO;
        self.bgView.y = IMS_SCREEN_HEIGHT - self.bgView.height;
    } completion:^(BOOL finished) {
    }];
}

- (void)hiddenView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.y = IMS_SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self.superview sendSubviewToBack:self];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self hiddenView];
    if (self.refreshUI) self.refreshUI();
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.mainTableView reloadData];
    if (dataArray.count) {
        [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }

    for (int i = 0; i < dataArray.count; ++i) {
        if (self.cellType == IMSPopupSingleSelectListViewRelatedCell || self.cellType == IMSPopupSingleSelectListViewSourceCampaignCell) {
            IMSPopupSingleSelectModel *model = dataArray[i];
            if (model.isSelected) {
                self.lastIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.mainTableView scrollToRowAtIndexPath:self.lastIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                break;
            } else {
                self.lastIndexPath = nil;
            }
        } else if (self.cellType == IMSPopupSingleSelectListViewSystemCell) {
            IMSPopupSingleSelectModel *model = dataArray[i];
            if (model.buttonState) {
                self.lastIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.mainTableView scrollToRowAtIndexPath:self.lastIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                break;
            } else {
                self.lastIndexPath = nil;
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMSPopupSingleSelectModel *model = self.dataArray[indexPath.row];
    switch (self.cellType) {
        case IMSPopupSingleSelectListViewSystemCell:
        {
            IMSPopupSingleSelect01TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupSingleSelect01TableViewCell class])];
            cell.model = model;
            return cell;
        }
            break;
        case IMSPopupSingleSelectListViewRelatedCell:
        {
            IMSPopupSingleSelect02TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupSingleSelect02TableViewCell class])];
            cell.dataModel = model;
            return cell;
        }
            break;
        case IMSPopupSingleSelectListViewSourceCampaignCell:
        {
            IMSPopupSingleSelect02TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupSingleSelect02TableViewCell class])];
            cell.sourceCampaignModel = model;
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.lastIndexPath isEqual:indexPath]) {
        if (self.refreshUI) self.refreshUI();
        [self hiddenView];
        return;
    }
    if (self.cellType == IMSPopupSingleSelectListViewSystemCell) {
        if (self.lastIndexPath) {
            IMSPopupSingleSelectModel *model = self.dataArray[self.lastIndexPath.row];
            model.buttonState = NO;
        }

        IMSPopupSingleSelectModel *model = self.dataArray[indexPath.row];
        model.buttonState = !model.buttonState;
        self.lastIndexPath = indexPath;

        if (self.didSelectedBlock) {
            self.didSelectedBlock(model);
            [self hiddenView];
        }
    } else if (self.cellType == IMSPopupSingleSelectListViewRelatedCell || self.cellType == IMSPopupSingleSelectListViewSourceCampaignCell) {
        if (self.lastIndexPath) {
            IMSPopupSingleSelectModel *model = self.dataArray[self.lastIndexPath.row];
            model.selected = NO;
        }
        IMSPopupSingleSelectModel *model = self.dataArray[indexPath.row];
        model.selected = !model.isSelected;
        self.lastIndexPath = indexPath;
        if (self.didSelectedBlock) {
            self.didSelectedBlock(model);
            [self hiddenView];
        }
    }
    if (self.refreshUI) self.refreshUI();
    [tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc]initWithString:@"No data" attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: IMS_HEXCOLOR(0xA4ABBF) }];
}

#pragma mark - lazy laod
- (UITableView *)mainTableView {
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, IMS_SCREEN_WIDTH, IMS_SCREEN_HEIGHT * 0.4) style:UITableViewStyleGrouped];
        _mainTableView.showsVerticalScrollIndicator = YES;
//        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 70;
//        _mainTableView.emptyDataSetSource = self;
//        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[IMSPopupSingleSelect02TableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMSPopupSingleSelect02TableViewCell class])];
        [_mainTableView registerClass:[IMSPopupSingleSelect01TableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMSPopupSingleSelect01TableViewCell class])];
    }
    return _mainTableView;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, IMS_SCREEN_HEIGHT, IMS_SCREEN_WIDTH, CGRectGetMaxY(self.mainTableView.frame))];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

@end
