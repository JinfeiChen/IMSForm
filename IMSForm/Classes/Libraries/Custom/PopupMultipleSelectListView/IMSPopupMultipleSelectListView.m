//
//  IMSPopupMultipleSelectListView.m
//  Raptor
//
//  Created by cjf on 22/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupMultipleSelectListView.h"
#import <IMSForm/IMSFormMacros.h>
#import <IMSForm/IMSPopupMultipleSelectTableViewSectionHeaderView.h>
#import <IMSForm/IMSPopupMultipleSelectTableViewCell.h>

@interface IMSPopupMultipleSelectListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UITableView *mainTableView;

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

- (void)showView {
    [self.superview bringSubviewToFront:self];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.hidden = NO;
        if (self.maxCount > 0) {
            self.tipLabel.hidden = NO;
            self.tipLabel.text =  [NSString stringWithFormat:@"%zd %@ selected(maximum %zd)", self.didSelectedCount, self.didSelectedCount > 1 ? @"items" : @"item", self.maxCount];
            self.tipLabel.height = 44;
        } else {
            self.tipLabel.hidden = YES;
            self.tipLabel.height = 10;
        }
        self.mainTableView.y =  CGRectGetMaxY(self.tipLabel.frame);
        self.bgView.height = self.mainTableView.height + self.tipLabel.height;
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
    _isGroup = [self isTwoDimensionArray:dataArray];
    _dataArray = dataArray;
    [self.mainTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isGroup) {
        return self.dataArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isGroup) {
        IMSPopupMultipleSelectModel *sectionModel = self.dataArray[section];
        return sectionModel.dataSourceArrayM.count;
    } else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMSPopupMultipleSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupMultipleSelectTableViewCell class])];
    IMSPopupMultipleSelectModel *model = nil;
    if (self.isGroup) {
        IMSPopupMultipleSelectModel *sectionModel = self.dataArray[indexPath.section];
        model = sectionModel.dataSourceArrayM[indexPath.row];
    } else {
        model = self.dataArray[indexPath.row];
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IMSPopupMultipleSelectModel *model = nil;
    if (self.isGroup) {
        IMSPopupMultipleSelectModel *sectionModel = self.dataArray[indexPath.section];
        model = sectionModel.dataSourceArrayM[indexPath.row];
    } else {
        model = self.dataArray[indexPath.row];
    }

    if (model.noSelect) return;

    /*
     Add/Edit 关于Role的选择：
     1、可以同时选择client、landlords、external agent和representative,只要选择这四个其中一个，就需要禁用掉estate management。
     2、选择了estate management，则需要禁用掉其他所有role.
     */

    model.buttonState = !model.buttonState;

    if (!self.isGroup) {
        if ([model.value.lowercaseString isEqualToString:@"estate management"]) {
            for (IMSPopupMultipleSelectModel *singleModel in self.dataArray) {
                if (singleModel != model) singleModel.noSelect = model.buttonState;
            }
        } else {
            BOOL isLastSelect = NO;
            IMSPopupMultipleSelectModel *managementModel = nil;
            for (IMSPopupMultipleSelectModel *singleModel in self.dataArray) {
                if ([singleModel.value.lowercaseString isEqualToString:@"estate management"]) {
                    managementModel = singleModel;
                } else {
                    if (singleModel.buttonState) isLastSelect = singleModel.buttonState;
                }
            }
            managementModel.noSelect =  isLastSelect;
        }
    }

    if (model.buttonState && self.maxCount > 0) {
        self.didSelectedCount++;
        if (self.didSelectedCount > self.maxCount) { // 超过最大数 label震动
            CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            shake.fromValue = [NSNumber numberWithFloat:-5];
            shake.toValue = [NSNumber numberWithFloat:5];
            shake.duration = 0.1;//执行时间
            shake.autoreverses = YES;//是否重复
            shake.repeatCount = 3;//次数
            [self.tipLabel.layer addAnimation:shake forKey:@"shakeAnimation"];
            self.didSelectedCount = self.maxCount;
            model.buttonState = NO;
            return;
        } else {
            self.tipLabel.text =  [NSString stringWithFormat:@"%zd %@ selected(maximum %zd)", self.didSelectedCount, self.didSelectedCount > 1 ? @"items" : @"item", self.maxCount];
        }
    } else if (!model.buttonState && self.maxCount > 0) {
        self.didSelectedCount--;
        self.tipLabel.text =  [NSString stringWithFormat:@"%zd %@ selected(maximum %zd)", self.didSelectedCount, self.didSelectedCount > 1 ? @"items" : @"item", self.maxCount];
    }

    if (self.didSelectedBlock) {
        self.didSelectedBlock(model, model.buttonState, self.tipLabel.text);
    }
    [tableView reloadData];
}

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc]initWithString:@"No data" attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: IMS_HEXCOLOR(0xA4ABBF) }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isGroup) {
        IMSPopupMultipleSelectModel *sectionModel = self.dataArray[section];
        IMSPopupMultipleSelectTableViewSectionHeaderView *headerView = [[IMSPopupMultipleSelectTableViewSectionHeaderView alloc]init];
        [headerView setupData:sectionModel.titleString andBackColor:[UIColor whiteColor] andTitleColor:IMS_HEXCOLOR(0xA4ABBF) andTitleFont:[UIFont systemFontOfSize:16]];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isGroup) {
        return 44;
    }
    return 0.01;
}

#pragma mark - Private Methods

// 判断数组是否为二维数组
- (BOOL)isTwoDimensionArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return NO;
    }
    for (id obj in array) {
        if ([obj isKindOfClass:[NSArray class]]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - lazy laod
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

- (UITableView *)mainTableView {
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tipLabel.frame), IMS_SCREEN_WIDTH, IMS_SCREEN_HEIGHT * 0.4) style:UITableViewStyleGrouped];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.estimatedRowHeight = 44;
//        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
//        _mainTableView.emptyDataSetSource = self;
//        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[IMSPopupMultipleSelectTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMSPopupMultipleSelectTableViewCell class])];
    }
    return _mainTableView;
}

@end
