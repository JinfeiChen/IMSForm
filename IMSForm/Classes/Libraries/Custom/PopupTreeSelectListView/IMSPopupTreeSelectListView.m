//
//  IMSPopupTreeSelectListView.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/13.
//

#import "IMSPopupTreeSelectListView.h"
#import "IMSPopupTreeTabView.h"


@interface IMSPopupTreeSelectListView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) IMSPopupTreeTabView *mainTableView;
@property (nonatomic, assign) NSInteger didSelectedCount;// 已经选择的数量
@end

@implementation IMSPopupTreeSelectListView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, IMS_SCREEN_WIDTH, IMS_SCREEN_HEIGHT);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        self.hidden = YES;
        self.isMultiple = YES;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.tipLabel];
        [self.bgView addSubview:self.mainTableView];
        [self dealData];
        [IMSAppWindow addSubview:self];
    }
    return self;
}

- (void)showView {
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.hidden = NO;
        if (self.maxCount >= 0) {
            self.tipLabel.hidden = NO;
            self.tipLabel.text =  [NSString stringWithFormat:@"%zd %@ selected(maximum %zd)",self.didSelectedCount,self.didSelectedCount > 1 ? @"items" : @"item",self.maxCount];
            self.tipLabel.height = 44;
        }else {
            self.tipLabel.hidden = YES;
            self.tipLabel.height = 10;
        }
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
        [self removeFromSuperview];
    }];
    if (self.didFinishedShowAndHideBlock) {
        self.didFinishedShowAndHideBlock(NO);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self hiddenView];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    self.mainTableView.dataArray = dataArray;
}

- (void)setSeleceDataSource:(NSMutableArray *)seleceDataSource {
    
    _seleceDataSource = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:seleceDataSource].mutableCopy;
    
    self.didSelectedCount = _seleceDataSource.count;
}

- (void)dealData {
    [self didSelectedBlock:self.mainTableView andFirstShow:YES];
}

- (void)didSelectedBlock:(IMSPopupTreeTabView *)tabView andFirstShow:(BOOL)isfirstShow {
    @weakify(self)
    @weakify(tabView)
    [tabView setDidSelectItemBlock:^(BOOL isShowChildView, IMSFormSelect * _Nonnull didSelectDataModel,NSString *treeTabViewTitleString) {
        @strongify(self)
        @strongify(tabView)
        
        if (self.isMultiple == NO) {
            for (IMSFormSelect *allModel in tabView.dataArray) {
                if (allModel != didSelectDataModel) {
                    allModel.selected = NO;
                    [self eachInDataSource:allModel.child andRelust:NO];
                }
            }
        }
        
        if (isShowChildView) {
            didSelectDataModel.selected = YES;
            IMSPopupTreeTabView *treeView = [[IMSPopupTreeTabView alloc]initWithFrame:CGRectMake(IMS_SCREEN_WIDTH, CGRectGetMaxY(self.tipLabel.frame), IMS_SCREEN_WIDTH, TableViewHeight)];
            [self.bgView addSubview:treeView];
            treeView.dataArray = didSelectDataModel.child;
            NSMutableString *titleMutString = [[NSMutableString alloc]init];
            if (isfirstShow == NO) {
                [titleMutString appendFormat:@"%@ > %@",treeTabViewTitleString,didSelectDataModel.label ?: didSelectDataModel.value];
            }else {
                [titleMutString appendString:didSelectDataModel.label ?: didSelectDataModel.value];
            }
            [treeView show:YES andTitle:titleMutString];
            for (IMSFormSelect *allModel in tabView.dataArray) {
                if ((allModel != didSelectDataModel) && allModel.child.count) {
                    allModel.selected = NO;
                }
            }
            [self didSelectedBlock:treeView andFirstShow:NO];
        }else { // 选择
            didSelectDataModel.selected = !didSelectDataModel.selected;
            if (didSelectDataModel.selected && self.maxCount >= 0) {
                self.didSelectedCount ++ ;
                if (self.didSelectedCount > self.maxCount) { // 超过最大数 label震动
                    self.didSelectedCount = self.maxCount;
                    didSelectDataModel.selected = 0;
                    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                    shake.fromValue = [NSNumber numberWithFloat:-5];
                    shake.toValue = [NSNumber numberWithFloat:5];
                    shake.duration = 0.1;//执行时间
                    shake.autoreverses = YES;//是否重复
                    shake.repeatCount = 3;//次数
                    [self.tipLabel.layer addAnimation:shake forKey:@"shakeAnimation"];
                    return;
                }
            }else if (!didSelectDataModel.selected && self.maxCount >= 0) {
                self.didSelectedCount --;
            }
            
            if (self.isMultiple == YES && didSelectDataModel.selected) { // add
                [self.seleceDataSource addObject:didSelectDataModel];
            }else if (self.isMultiple == YES && !didSelectDataModel.selected ) { // sub
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"value contains %@",didSelectDataModel.value];
                [self.seleceDataSource removeObjectsInArray:[self.seleceDataSource filteredArrayUsingPredicate:predicate]];
            }
        
            NSString *titleLabelText = [NSString stringWithFormat:@"%@ %@ %@",treeTabViewTitleString ?: @"", treeTabViewTitleString ? @">":@"", didSelectDataModel.label ?: didSelectDataModel.value];
            if (self.isMultiple == NO ) {
                [self.seleceDataSource removeAllObjects];
                if (didSelectDataModel.selected) [self.seleceDataSource addObject:didSelectDataModel];
                if (!didSelectDataModel.selected) titleLabelText = @"";
            }
            
            self.tipLabel.text =  [NSString stringWithFormat:@"%zd %@ selected(maximum %zd)",self.didSelectedCount,self.didSelectedCount > 1 ? @"items" : @"item",self.maxCount];
            if (self.didSelectedBlock) {
                self.didSelectedBlock([self.seleceDataSource yy_modelToJSONObject],didSelectDataModel, titleLabelText);
            }
        }
    }];
}

- (void)eachInDataSource:(NSArray *)dataSource andRelust:(BOOL)result {
    for (IMSFormSelect *model in dataSource) {
        model.selected = result;
        if (model.selected == NO && model.child.count) {
            [self eachInDataSource:model.child andRelust:result];
        }
    }
}

#pragma mark - lazy laod
- (IMSPopupTreeTabView *)mainTableView {
    if (_mainTableView == nil) {
        _mainTableView = [[IMSPopupTreeTabView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tipLabel.frame), IMS_SCREEN_WIDTH, TableViewHeight)];
    }
    return _mainTableView;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, IMS_SCREEN_HEIGHT, IMS_SCREEN_WIDTH, self.tipLabel.height + self.mainTableView.height)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, IMS_SCREEN_WIDTH - 20, 0)];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textColor = IMS_HEXCOLOR(0xE7A748);
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

@end
