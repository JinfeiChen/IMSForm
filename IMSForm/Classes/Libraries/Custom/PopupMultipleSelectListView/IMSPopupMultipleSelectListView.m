//
//  IMSPopupMultipleSelectListView.m
//  Raptor
//
//  Created by cjf on 22/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupMultipleSelectListView.h"

#import <IMSForm/IMSPopupMultipleSelectTableViewSectionHeaderView.h>
#import <IMSForm/IMSPopupMultipleSelectTableViewCell.h>

@interface IMSPopupMultipleSelectListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) CJFTableView *mainTableView;

@property (nonatomic, assign) BOOL isGroup; // 是否以组的形式显示,默认为不是
@property (strong, nonatomic) NSArray *selectedDataArray; /**< 已选中列表 */

@end

@implementation IMSPopupMultipleSelectListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, IMS_SCREEN_WIDTH, IMS_SCREEN_HEIGHT)]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        self.hidden = YES;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.tipLabel];
        [self.bgView addSubview:self.mainTableView];
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
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.hidden = NO;
        if (self.maxCount != 0) {
            self.tipLabel.hidden = NO;
            [self updateTipLabelText];
            self.tipLabel.height = 44;
        }
        else {
            self.tipLabel.hidden = YES;
            self.tipLabel.height = 10;
        }
        self.tipLabel.textColor = self.tintColor;
        self.mainTableView.y =  CGRectGetMaxY(self.tipLabel.frame);
        self.bgView.height = self.mainTableView.height + self.tipLabel.height;
        self.bgView.y = IMS_SCREEN_HEIGHT - self.bgView.height;
    } completion:^(BOOL finished) {
    }];
    if (self.didFinishedShowAndHideBlock) {
        self.didFinishedShowAndHideBlock(YES);
    }
}

- (void)hiddenView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.y = IMS_SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self.superview sendSubviewToBack:self];
    }];
    if (self.didFinishedShowAndHideBlock) {
        self.didFinishedShowAndHideBlock(NO);
    }
}

- (void)setDataArray:(NSArray *)dataArray type:(IMSPopupMultipleSelectListViewCellType)cellType selectedDataArray:(nonnull NSArray *)selectedDataArray
{
    if (!dataArray || dataArray.count == 0) { // 空数据处理
        self.dataArray = @[];
        self.mainTableView.placeholderStyle = CJFTableViewPlaceholderStyle_NoData;
        [self.mainTableView reloadData];
        return;
    }
    
    self.mainTableView.placeholderStyle = CJFTableViewPlaceholderStyle_Default;
    _cellType = cellType;
    
    // 数据分组处理
    NSMutableArray *groupTitles = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dict = dataArray[i];
        NSString *groupTitle = [dict valueForKey:@"groupTitle"];
        if (groupTitle) {
            [groupTitles addObject:groupTitle];
        }
    }
    groupTitles = [[[groupTitles valueForKeyPath:@"@distinctUnionOfObjects.self"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }] copy]; //去重
    if (groupTitles.count > 0) {
        NSMutableArray *newDataArray = [NSMutableArray array];
        for (NSString *title in groupTitles) {
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
            [mDict setValue:title forKey:@"groupTitle"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.groupTitle == %@", title];
            NSArray *result = [dataArray filteredArrayUsingPredicate:predicate];
            [mDict setValue:result forKey:@"child"];
            [newDataArray addObject:mDict];
        }
        dataArray = newDataArray;
    }
    
    _isGroup = [self isTwoDimensionArray:dataArray];
    
    switch (cellType) {
        case IMSPopupMultipleSelectListViewCellType_Custom:
        {
            NSString *clsStr = [self customClassStringOfTableViewCellModel];
            self.selectedDataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(clsStr) json:selectedDataArray];
            self.dataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(clsStr) json:dataArray];
        }
            break;
          
        case IMSPopupMultipleSelectListViewCellType_Default:
        default:
        {
            self.selectedDataArray = [NSArray yy_modelArrayWithClass:[IMSPopupMultipleSelectModel class] json:selectedDataArray];
            self.dataArray = [NSArray yy_modelArrayWithClass:[IMSPopupMultipleSelectModel class] json:dataArray];
        }
            break;
    }
    self.didSelectedCount = self.selectedDataArray.count;
    
    for (IMSFormSelect *obj in self.dataArray) {
        if (_isGroup) {
            for (IMSFormSelect *childObj in obj.child) {
                BOOL selected = NO;
                for (IMSFormSelect *subObj in self.selectedDataArray) {
                    if ([childObj.value isEqualToString:subObj.value]) {
                        selected = YES;
                        break;
                    }
                }
                childObj.selected = selected;
            }
        } else {
            BOOL selected = NO;
            for (IMSFormSelect *subObj in self.selectedDataArray) {
                if ([obj.value isEqualToString:subObj.value]) {
                    selected = YES;
                    break;
                }
            }
            obj.selected = selected;
        }
    }
    
    [self.mainTableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isGroup) {
        return self.dataArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isGroup) {
        IMSFormSelect *sectionModel = self.dataArray[section];
        return sectionModel.child.count;
    } else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.cellType) {
        case IMSPopupMultipleSelectListViewCellType_Custom:
        {
            return [self customTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
          
        case IMSPopupMultipleSelectListViewCellType_Default:
        default:
        {
            IMSPopupMultipleSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupMultipleSelectTableViewCell class])];
            IMSPopupMultipleSelectModel *model = nil;
            if (self.isGroup) {
                IMSPopupMultipleSelectModel *sectionModel = self.dataArray[indexPath.section];
                model = (IMSPopupMultipleSelectModel *)sectionModel.child[indexPath.row];
            } else {
                model = self.dataArray[indexPath.row];
            }
            cell.tintColor = self.tintColor;
            cell.model = model;
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IMSFormSelect *model = nil;
    if (self.isGroup) {
        IMSFormSelect *sectionModel = self.dataArray[indexPath.section];
        model = (IMSFormSelect *)sectionModel.child[indexPath.row];
    } else {
        model = self.dataArray[indexPath.row];
    }
    
    if (!model.isEnable) return;
    
    if (!model.isSelected) {
        if (self.didSelectedCount >= self.maxCount && self.maxCount >= 0) { // 超过最大数 label震动
            CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            shake.fromValue = [NSNumber numberWithFloat:-5];
            shake.toValue = [NSNumber numberWithFloat:5];
            shake.duration = 0.1;//执行时间
            shake.autoreverses = YES;//是否重复
            shake.repeatCount = 3;//次数
            [self.tipLabel.layer addAnimation:shake forKey:@"shakeAnimation"];
            return;
        }
    }
    
    model.selected = !model.isSelected;
    // 更新当前分区的全选状态
    if (self.isGroup) {
        IMSFormSelect *sectionModel = self.dataArray[indexPath.section];
        __block BOOL isSelectAll = YES;
        [sectionModel.child enumerateObjectsUsingBlock:^(IMSFormSelect * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.isSelected) {
                isSelectAll = NO;
            }
        }];
        sectionModel.selected = isSelectAll;
    }

    if (model.isSelected) {
        self.didSelectedCount++;
    } else {
        self.didSelectedCount--;
    }
    [self updateTipLabelText];

    NSMutableArray *mArr = [NSMutableArray array];
    for (IMSFormSelect *obj in self.dataArray) {
        if (self.isGroup) {
            if (obj.child && obj.child.count > 0) {
                for (IMSFormSelect *subObj in obj.child) {
                    if (subObj.isSelected) {
                        [mArr addObject:subObj];
                    }
                }
            }
        } else {
            if (obj.isSelected) {
                [mArr addObject:obj];
            }
        }
    }
    if (self.didSelectedBlock) {
        self.didSelectedBlock([mArr yy_modelToJSONObject], model, model.isSelected, self.tipLabel.text);
    }
    
    [tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isGroup) {
        IMSFormSelect *sectionModel = self.dataArray[section];
        IMSPopupMultipleSelectTableViewSectionHeaderView *headerView = [[IMSPopupMultipleSelectTableViewSectionHeaderView alloc]init];
        [headerView setupData:sectionModel.groupTitle andBackColor:[UIColor whiteColor] andTitleColor:IMS_HEXCOLOR(0xA4ABBF) andTitleFont:[UIFont systemFontOfSize:16]];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isGroup) {
        return 44.0;
    }
    return 0.01;
}

#pragma mark - Private Methods

- (void)updateTipLabelText
{
    // maxCount
    // -1 表示不限制最大选择数
    // 0 表示不能选择
    // n 表示限制选择数
    NSString *tip = (self.maxCount > 0) ? [NSString stringWithFormat:@"(maximum %zd)", self.maxCount] : @"";
    self.tipLabel.text = [NSString stringWithFormat:@"%zd %@ selected%@", self.didSelectedCount, self.didSelectedCount > 1 ? @"items" : @"item", tip];
}

- (NSString *)customClassStringOfTableViewCellModel
{
    return @"IMSFormSelect";
}

- (UITableViewCell *)customTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMSPopupMultipleSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupMultipleSelectTableViewCell class])];
    IMSFormSelect *model = nil;
    if (self.isGroup) {
        IMSFormSelect *sectionModel = self.dataArray[indexPath.section];
        model = (IMSFormSelect *)sectionModel.child[indexPath.row];
    } else {
        model = self.dataArray[indexPath.row];
    }
    cell.model = model;
    return cell;
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc]initWithString:@"No data" attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: IMS_HEXCOLOR(0xA4ABBF) }];
}

// 判断数组是否为二维数组
- (BOOL)isTwoDimensionArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return NO;
    }
    NSArray *tempArr = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:array];
    for (IMSFormSelect *obj in tempArr) {
        if (obj.child && obj.child.count > 0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Getters

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, IMS_SCREEN_HEIGHT, IMS_SCREEN_WIDTH, self.tipLabel.height + self.mainTableView.height)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, IMS_SCREEN_WIDTH - 20, 10)];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textColor = IMS_HEXCOLOR(0xFFC24B);
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

- (CJFTableView *)mainTableView {
    if (_mainTableView == nil) {
        _mainTableView = [[CJFTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tipLabel.frame), IMS_SCREEN_WIDTH, IMS_SCREEN_HEIGHT * 0.4) style:UITableViewStyleGrouped];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.estimatedRowHeight = 44;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[IMSPopupMultipleSelectTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMSPopupMultipleSelectTableViewCell class])];
    }
    return _mainTableView;
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
