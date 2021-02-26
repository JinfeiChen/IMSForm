//
//  IMSPopupSingleSelectListView.m
//  Raptor
//
//  Created by cjf on 18/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupSingleSelectListView.h"

@interface IMSPopupSingleSelectListView ()  <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation IMSPopupSingleSelectListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, IMS_SCREEN_WIDTH, IMS_SCREEN_HEIGHT)]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        self.hidden = YES;
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.mainTableView];
        [IMSAppWindow addSubview:self];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self hiddenView];
}

#pragma mark - Public Methods

- (void)showView {
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.hidden = NO;
        self.contentView.y = IMS_SCREEN_HEIGHT - self.contentView.height;
    } completion:^(BOOL finished) {
        
    }];
    if (self.didFinishedShowAndHideBlock) {
        self.didFinishedShowAndHideBlock(YES);
    }
}

- (void)hiddenView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.y = IMS_SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self.superview sendSubviewToBack:self];
    }];
    if (self.didFinishedShowAndHideBlock) {
        self.didFinishedShowAndHideBlock(NO);
    }
}

- (void)setDataArray:(NSArray *)dataArray type:(IMSPopupSingleSelectListViewCellType)type
{
    if (!dataArray || dataArray.count == 0) { // 空数据的处理
        self.dataArray = @[];
        self.mainTableView.placeholderStyle = CJFTableViewPlaceholderStyle_NoData;
        [self.mainTableView reloadData];
        return;
    }
    
    self.mainTableView.placeholderStyle = CJFTableViewPlaceholderStyle_Default;
    _cellType = type;
    
    switch (type) {
        case IMSPopupSingleSelectListViewCellType_Custom:
        {
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dict in dataArray) {
                [mArr addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
            }
            self.dataArray = mArr;
        }
            break;
        case IMSPopupSingleSelectListViewCellType_Location:
        {
            self.dataArray = [NSArray yy_modelArrayWithClass:[IMSPopupSingleSelectLocationModel class] json:dataArray];
        }
            break;
        case IMSPopupSingleSelectListViewCellType_Contact:
        {
            self.dataArray = [NSArray yy_modelArrayWithClass:[IMSPopupSingleSelectContactModel class] json:dataArray];
        }
            break;
            
        case IMSPopupSingleSelectListViewCellType_Default:
        default:
        {
            self.dataArray = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:dataArray];
        }
            break;
    }
    
    switch (type) {
        case IMSPopupSingleSelectListViewCellType_Custom:
        {
            for (int i = 0; i < self.dataArray.count; i++) {
                NSDictionary *obj = self.dataArray[i];
                NSNumber *selected = [obj valueForKey:@"selected"];
                if (selected) {
                    self.lastIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    if (self.lastIndexPath.row < [self.mainTableView numberOfRowsInSection:0]) {
                        [self.mainTableView scrollToRowAtIndexPath:self.lastIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }
                    break;
                } else {
                    self.lastIndexPath = nil;
                }
            }
        }
            break;
            
        default:
        {
            for (int i = 0; i < self.dataArray.count; i++) {
                IMSFormSelect *obj = self.dataArray[i];
                if (obj.isSelected) {
                    self.lastIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    if (self.lastIndexPath.row < [self.mainTableView numberOfRowsInSection:0]) {
                        [self.mainTableView scrollToRowAtIndexPath:self.lastIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                    }
                    break;
                } else {
                    self.lastIndexPath = nil;
                }
            }
        }
            break;
    }
    [self.mainTableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.cellType) {
        case IMSPopupSingleSelectListViewCellType_Custom:
        {
            return [self customTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
        case IMSPopupSingleSelectListViewCellType_Location:
        {
            IMSPopupSingleSelectLocationModel *model = (IMSPopupSingleSelectLocationModel *)self.dataArray[indexPath.row];
            IMSPopupSingleSelectLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupSingleSelectLocationTableViewCell class])];
            cell.tintColor = self.tintColor;
            cell.model = model;
            return cell;
        }
            break;
        case IMSPopupSingleSelectListViewCellType_Contact:
        {
            IMSPopupSingleSelectContactModel *model = (IMSPopupSingleSelectContactModel *)self.dataArray[indexPath.row];
            IMSPopupSingleSelectContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupSingleSelectContactTableViewCell class])];
            cell.tintColor = self.tintColor;
            cell.model = model;
            return cell;
        }
            break;
            
        case IMSPopupSingleSelectListViewCellType_Default:
        default:
        {
            IMSFormSelect *model= self.dataArray[indexPath.row];
            IMSPopupSingleSelectDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupSingleSelectDefaultTableViewCell class])];
            cell.tintColor = self.tintColor;
            cell.model = model;
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.cellType) {
        case IMSPopupSingleSelectListViewCellType_Custom:
        {
            NSMutableDictionary *dict = (NSMutableDictionary *)self.dataArray[indexPath.row];
            NSNumber *enable = [dict valueForKey:@"enable"];
            if (enable && ![enable boolValue]) {
                return;
            }
            for (NSMutableDictionary *obj in self.dataArray) {
                [obj setValue:@(NO) forKey:@"selected"];
            }
            [dict setValue:@([self.lastIndexPath isEqual:indexPath] ? NO : YES) forKey:@"selected"];
            if (self.didSelectedBlock) {
                self.didSelectedBlock(self.dataArray, [IMSFormSelect yy_modelWithDictionary:dict]);
            }
            self.lastIndexPath = [self.lastIndexPath isEqual:indexPath] ? nil : indexPath;

            [tableView reloadData];
            [self hiddenView];
        }
            break;
        case IMSPopupSingleSelectListViewCellType_Location:
        {
            for (IMSFormSelect *obj in self.dataArray) {
                obj.selected = NO;
            }
            IMSFormSelect *model = (IMSFormSelect *)self.dataArray[indexPath.row];
            model.selected = [self.lastIndexPath isEqual:indexPath] ? NO : YES;
            if (self.didSelectedLocationBlock) {
                self.didSelectedLocationBlock([self.dataArray yy_modelToJSONObject], model, indexPath);
            }
            self.lastIndexPath = [self.lastIndexPath isEqual:indexPath] ? nil : indexPath;

            [tableView reloadData];
            [self hiddenView];
        }
            break;
        default:
        {
            for (IMSFormSelect *obj in self.dataArray) {
                obj.selected = NO;
            }
            IMSFormSelect *model = (IMSFormSelect *)self.dataArray[indexPath.row];
            model.selected = [self.lastIndexPath isEqual:indexPath] ? NO : YES;
            if (self.didSelectedBlock) {
                self.didSelectedBlock([self.dataArray yy_modelToJSONObject], model);
            }
            self.lastIndexPath = [self.lastIndexPath isEqual:indexPath] ? nil : indexPath;

            [tableView reloadData];
            [self hiddenView];
        }
            break;
    }
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

#pragma mark - Private Methods

- (UITableViewCell *)customTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMSFormSelect *model= self.dataArray[indexPath.row];
    IMSPopupSingleSelectDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupSingleSelectDefaultTableViewCell class])];
    cell.model = model;
    return cell;
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc]initWithString:@"No data" attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: IMS_HEXCOLOR(0xA4ABBF) }];
}

#pragma mark - lazy laod
- (CJFTableView *)mainTableView {
    if (_mainTableView == nil) {
        _mainTableView = [[CJFTableView alloc] initWithFrame:CGRectMake(0, 10, IMS_SCREEN_WIDTH, IMS_SCREEN_HEIGHT * 0.4) style:UITableViewStyleGrouped];
        _mainTableView.showsVerticalScrollIndicator = YES;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 70;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[IMSPopupSingleSelectLocationTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMSPopupSingleSelectLocationTableViewCell class])];
        [_mainTableView registerClass:[IMSPopupSingleSelectContactTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMSPopupSingleSelectContactTableViewCell class])];
        [_mainTableView registerClass:[IMSPopupSingleSelectDefaultTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMSPopupSingleSelectDefaultTableViewCell class])];
    }
    return _mainTableView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, IMS_SCREEN_HEIGHT, IMS_SCREEN_WIDTH, CGRectGetMaxY(self.mainTableView.frame))];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

// MARK: 可实现此方法自定义noDataView/errorNetworkView
//- (UIView *)placeholderView
//{
//    switch (self.mainTableView.placeholderStyle) {
//        case CJFTableViewPlaceholderStyle_Default:
//        {
//            return [UIView new];
//        }
//            break;
//        case CJFTableViewPlaceholderStyle_NoData:
//        {
//            return self.mainTableView.noDataPlaceholderView;
//        }
//            break;
//        case CJFTableViewPlaceholderStyle_ErrorNetWork:
//        {
//            return self.mainTableView.errorNetworkPlaceholderView;
//        }
//            break;
//        default:
//            return nil;
//            break;
//    }
//}

@end
