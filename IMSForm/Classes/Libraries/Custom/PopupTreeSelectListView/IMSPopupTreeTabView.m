//
//  IMSPopupTreeTabView.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/13.
//

#import "IMSPopupTreeTabView.h"
#import <IMSForm/UIView+Extension.h>
#import <Masonry/Masonry.h>
#import "UIImage+Bundle.h"

@interface IMSPopupTreeTabView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *tabHeaderView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) BOOL isShowTabHeader;
@end

@implementation IMSPopupTreeTabView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
        [self removeFromSuperview];
    }];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.mainTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    IMSPopupTreeTabCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IMSPopupTreeTabCell class])];
    IMSFormSelect *dataModel = self.dataArray[indexPath.row];
    [cell setupData:dataModel andIsLast:!dataModel.child.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     IMSFormSelect *dataModel = self.dataArray[indexPath.row];
    
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(dataModel.child.count, dataModel,self.backButton.titleLabel.text);
        [tableView reloadData];
    }
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
        _mainTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.backgroundColor = [UIColor whiteColor];
//        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
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
        [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        [_backButton setImage: [UIImage bundleImageWithNamed:@"ic_left_arrow"] forState:UIControlStateNormal];
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
