//
//  IMSPopupTreeTabView.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/13.
//

#import "IMSPopupTreeTabView.h"
#import <IMSForm/UIView+Extension.h>
#import "IMSPopupTreeTabCell.h"
#import <Masonry/Masonry.h>

@interface IMSPopupTreeTabView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *tabHeaderView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) BOOL isShowTabHeader;
@end

@implementation IMSPopupTreeTabView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.frame = frame;
        [self addSubview:self.mainTableView];
    }
    return self;
}

- (void)show:(BOOL)isShowTabHeader andTitle:(NSString *)title {
    self.isShowTabHeader = isShowTabHeader;
    if (isShowTabHeader) {
        [self.backButton setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.x = 0;
    } completion:^(BOOL finished) {
    }];
    [self.mainTableView reloadData];
}

- (void)hiddenView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.x = IMS_SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        NSString *replaceString = [NSString stringWithFormat:@"%@>",self.backButton.titleLabel.text];
    }];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

//- (void)lj_bindViewModel {
//    @weakify(self)
//    [self.viewModel.sureClickSubject subscribeNext:^(NSDictionary *x) {
//        @strongify(self)
//        if (self.maxCount > 0)  self.didSelectedCount = [[x objectForKey:@"didSelectedCount"] integerValue];
//    }];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    IMSPopupTreeTabCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupTreeTabCell class])];
    IMSFormSelect *dataModel = self.dataArray[indexPath.row];
    [cell setupData:dataModel andIsLast:dataModel.child.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     IMSFormSelect *dataModel = self.dataArray[indexPath.row];
//
//    if (!kArrayIsEmpty(dataModel.childArray)) { // 显示下一级
//        dataModel.buttonState = 1;
//        RAAddContactLocationTabView *view = [[RAAddContactLocationTabView alloc]initWithViewModel:self.viewModel andFrame:CGRectMake(IMSScreen_Width,0, IMSScreen_Width, AddContactLocationHeight)];
//        view.isSingleSelect = self.isSingleSelect;
//        view.maxCount = self.maxCount;
//        view.didSelectedCount = self.didSelectedCount;
//        [self addSubview:view];
//        view.dataArray = dataModel.childArray;
//        [view show:YES andTitle:dataModel.value];
//
//        // 拼接选择的标题
//        [self.viewModel.titleMutString appendFormat:@"%@>",dataModel.value];
//        DLog(@"==>%@",self.viewModel.titleMutString)
//        for (RAContactsFilterRightTabManySelectedModel *allModel in self.dataArray) {
//            if (allModel != dataModel) {
//                allModel.buttonState = 0;
////                for (RAContactsFilterRightTabManySelectedModel *childModel in allModel.childArray) {
////                    childModel.buttonState = 0;
////                    for (RAContactsFilterRightTabManySelectedModel *childModelTwo in childModel.childArray) {
////                        childModelTwo.buttonState = 0;
////                    }
////                }
//            }
//        }
//        [tableView reloadData];
//    }else { // 选中逻辑
//        if (dataModel.buttonState == 1) {
//            dataModel.buttonState = 0;
//        }else if (dataModel.buttonState == 0) {
//            dataModel.buttonState = 1;
//        }
//        BOOL isShakeAnimation = NO;
//        if (dataModel.buttonState == 1 && self.maxCount > 0) {
//            self.didSelectedCount ++;
//            if (self.didSelectedCount > self.maxCount) { // 超过最大数 label震动
//                isShakeAnimation = YES;
//                self.didSelectedCount = self.maxCount;
//                dataModel.buttonState = 0;
//            }
//        }else if (dataModel.buttonState == 0 && self.maxCount > 0) {
//            self.didSelectedCount --;
//        }
//        if (self.isSingleSelect) {
//            for (RAContactsFilterRightTabManySelectedModel *allModel in self.dataArray) {
//                if (allModel != dataModel) {
//                    allModel.buttonState = 0;
//                    for (RAContactsFilterRightTabManySelectedModel *childModel in allModel.childArray) {
//                        childModel.buttonState = 0;
//                        for (RAContactsFilterRightTabManySelectedModel *childModelTwo in childModel.childArray) {
//                            childModelTwo.buttonState = 0;
//                        }
//                    }
//                }
//            }
//        }
//        NSString *resultString = [NSString stringWithFormat:@"%@",dataModel.value];
//        DLog(@"==>%@",resultString);
//        [self.viewModel.sureClickSubject sendNext:@{@"value":resultString,
//                                                    @"Id":dataModel.Id,
//                                                    @"isSingleSelect":@(self.isSingleSelect),
//                                                    @"isAdd":@(dataModel.buttonState),
//                                                    @"isShakeAnimation":@(isShakeAnimation),
//                                                    @"didSelectedCount" : @(self.didSelectedCount)
//        }];
//
//        [tableView reloadData];
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isShowTabHeader) {
        return self.tabHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   if (self.isShowTabHeader) {
        return 40;
    }
    return 0.01;
}

#pragma mark - lazy load
- (UITableView *)mainTableView {
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.bounds];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.bounces = NO;
        [_mainTableView registerClass:[IMSPopupTreeTabCell class] forCellReuseIdentifier:NSStringFromClass([IMSPopupTreeTabCell class])];
        
    }
    return _mainTableView;
}

- (UIView *)tabHeaderView {
    if (_tabHeaderView == nil) {
        _tabHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IMS_SCREEN_WIDTH, 40)];
        _tabHeaderView.backgroundColor = [UIColor whiteColor];
        
        [_tabHeaderView addSubview:self.backButton];
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_tabHeaderView);
            make.left.equalTo(_tabHeaderView).offset(15);
            make.right.equalTo(_tabHeaderView).offset(-15);
        }];
    }
    return _tabHeaderView;
}

- (UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"ev_back"] forState:UIControlStateNormal];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _backButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    }
    return _backButton;
}

@end
