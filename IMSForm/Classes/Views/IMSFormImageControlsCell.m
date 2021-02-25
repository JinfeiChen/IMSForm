//
//  IMSFormImageControlsCell.m
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import "IMSFormImageControlsCell.h"

@interface IMSFormImageControlsItemCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView; /**< <#property#> */
@property (strong, nonatomic) UIImageView *selImageView; /**< <#property#> */

- (void)beginShake;
- (void)stopShake;

@end

@implementation IMSFormImageControlsItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];

        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        
        _selImageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage bundleImageWithNamed:@"select"];
        _selImageView.image = image;
        [self addSubview:_selImageView];
        [_selImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.bottom.mas_equalTo(self).offset(0);
        }];
//        _selImageView.hidden = YES;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}

// 实现cell抖动方法
- (void)beginShake
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.duration = 0.2;
    anim.repeatCount = MAXFLOAT;
    anim.values = @[@(-0.03),@(0.03),@(-0.03)];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anim forKey:@"shake"];
}

// 实现cell停止抖动方法
- (void)stopShake
{
    [self.layer removeAllAnimations];
}

@end


@interface IMSFormImageControlsCell () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGFloat _itemWH;
    CGFloat _margin;
    BOOL _isItemShake;
}

@property (strong, nonatomic) UICollectionView *collectionView; /**< <#property#> */
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout; /**< <#property#> */

@property (strong, nonatomic) IMSFormImageControlsItemCell *movingCell; /**< <#property#> */

@end

@implementation IMSFormImageControlsCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildView];
    }
    return self;
}

#pragma mark - UI

- (void)buildView
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.collectionView];

    [self updateUI];
}

- (void)updateUI
{
    self.contentView.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.backgroundHexColor]);

    self.titleLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.titleHexColor]);
    self.titleLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.titleFontSize weight:UIFontWeightMedium];

    self.infoLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.infoFontSize weight:UIFontWeightRegular];
    self.infoLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.infoHexColor]);

    CGFloat spacing = self.model.cpnStyle.spacing;

    self.bodyView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    self.collectionView.backgroundColor = self.bodyView.backgroundColor;

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.top);
        make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
        make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
    }];
    [self.bodyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(spacing);
        make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
        make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
    }];
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.bodyView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bodyView).with.insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - Private Methods

// 清除重用数据
- (void)clearReuseData
{
    self.titleLabel.text = @"";
    self.infoLabel.text = @"";
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];

    [self updateUI];

    [self clearReuseData];
    [self setTitle:model.title required:model.isRequired];

    self.infoLabel.text = model.info;
    
    // update default valueList
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.selected = YES"];
    self.model.valueList = [[self.model.cpnConfig.dataSource filteredArrayUsingPredicate:predicate] mutableCopy];

    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.model.cpnConfig.dataSource.count >= self.model.cpnConfig.maxImagesLimit) ? self.model.cpnConfig.maxImagesLimit : self.model.cpnConfig.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMSFormImageControlsItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IMSFormImageControlsItemCell class]) forIndexPath:indexPath];
    NSDictionary *dict = self.model.cpnConfig.dataSource[indexPath.item];
    NSString *urlStr = [NSString stringWithFormat:@"%@", [dict valueForKey:@"url"]];
    NSURL *imgURL =  [NSURL URLWithString:urlStr];
    [cell.imageView yy_setImageWithURL:imgURL options:YYWebImageOptionProgressive];
    NSNumber *selected = [dict objectForKey:@"selected"];
//    cell.selImageView.hidden = ![selected boolValue];
    cell.selImageView.tintColor = [selected boolValue] ? IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]) : [UIColor whiteColor];
    cell.selImageView.alpha = [selected boolValue] ? 1.0 : 0.5;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // update datasource selected
    NSMutableArray *mDataSource = [NSMutableArray arrayWithArray:self.model.cpnConfig.dataSource];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:mDataSource[indexPath.item]];
    NSNumber *selected = [mDict objectForKey:@"selected"];
    [mDict setValue:@(![selected boolValue]) forKey:@"selected"];
    [mDataSource replaceObjectAtIndex:indexPath.item withObject:mDict];
    self.model.cpnConfig.dataSource = mDataSource;
    
    // update model valueList
    [self updateSelectedImages];
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

// 开启collectionView可以移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 处理collectionView移动过程中的数据操作
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray *mDataSource = [NSMutableArray arrayWithArray:self.model.cpnConfig.dataSource];
    
    //取出移动row 数据
    NSDictionary *dic = mDataSource[sourceIndexPath.row];
    //从数据源中移除该数据
    [mDataSource removeObject:dic];
    
    //将数据插入到数据源中目标位置
    [mDataSource insertObject:dic atIndex:destinationIndexPath.row];
    
    // MARK: 排序(停止拖拽)后更新数据源顺序
    self.model.cpnConfig.dataSource = mDataSource;
    
    NSArray *cellArray = [self.collectionView visibleCells];
    for (IMSFormImageControlsItemCell *cell in cellArray ) {
        [cell stopShake];
    }
}

#pragma mark - UIView (UIConstraintBasedLayoutFittingSize)

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    if (!self.model) {
        return targetSize;
    }
    // 先对bgview进行布局,这里需对bgView布局后collectionView宽度才会准确
    self.bodyView.frame = CGRectMake(0, 0, targetSize.width, 44);
    [self.bodyView layoutIfNeeded];

    // 再对collectionView进行布局
    self.collectionView.frame = CGRectMake(0, 0, targetSize.width - self.model.cpnStyle.contentInset.left - self.model.cpnStyle.contentInset.right, 44);
    [self.collectionView layoutIfNeeded];

    _margin = 10;
    _itemWH = (targetSize.width - self.model.cpnStyle.contentInset.left - self.model.cpnStyle.contentInset.right - (self.model.cpnConfig.rowImages - 1) * _margin - 2 * _margin) / self.model.cpnConfig.rowImages;
    self.flowLayout.itemSize = CGSizeMake(_itemWH, _itemWH);
//    [self.collectionView layoutIfNeeded];

    YYLabel *contentL = [[YYLabel alloc] init];
    //计算标题文本尺寸
    NSMutableAttributedString *titleAttri = [[NSMutableAttributedString alloc] initWithString:self.model.title];
    CGSize maxSize = CGSizeMake(targetSize.width - self.model.cpnStyle.contentInset.left - self.model.cpnStyle.contentInset.right, MAXFLOAT);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:titleAttri];
    contentL.textLayout = layout;
    CGFloat titleHeight = layout.textBoundingSize.height < 15 ? layout.textBoundingSize.height : 15;

    NSMutableAttributedString *infoAttri = [[NSMutableAttributedString alloc] initWithString:self.model.info];
    maxSize = CGSizeMake(targetSize.width - self.model.cpnStyle.contentInset.left - self.model.cpnStyle.contentInset.right, MAXFLOAT);
    layout = [YYTextLayout layoutWithContainerSize:maxSize text:infoAttri];
    contentL.textLayout = layout;
    CGFloat infoHeight = layout.textBoundingSize.height;

    // 由于这里collection的高度是动态的，这里cell的高度我们根据collection来计算
    CGSize collectionSize = self.collectionView.collectionViewLayout.collectionViewContentSize;
    CGFloat contentHeight = collectionSize.height + self.model.cpnStyle.contentInset.top + self.model.cpnStyle.contentInset.bottom + titleHeight + self.collectionView.contentInset.top + self.collectionView.contentInset.bottom + infoHeight + self.model.cpnStyle.spacing + 10;
    return CGSizeMake(targetSize.width, contentHeight);
}

#pragma mark - Private Methods

- (void)updateSelectedImages
{
    NSMutableArray *mArr = [NSMutableArray array];
    [self.model.cpnConfig.dataSource enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSNumber *selected = [obj objectForKey:@"selected"];
            if ([selected boolValue]) {
                [mArr addObject:obj];
            }
        }
    }];
    self.model.valueList = mArr;
}

#pragma mark - Actions

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            {
                //手势开始
                //判断手势落点位置是否在row上
                NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
                if (indexPath == nil) {
                    break;
                }
                IMSFormImageControlsItemCell *currentCell = (IMSFormImageControlsItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [self bringSubviewToFront:currentCell];
                //iOS9 方法 移动cell
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
                
                _isItemShake = YES;
                NSArray *cellArray = [self.collectionView visibleCells];
                for (IMSFormImageControlsItemCell *cell in cellArray ) {
                    if (cell != currentCell) {
                        // 调用cell抖动方法
                        if (_isItemShake) {
                            [cell beginShake];
                        } else {
                            [cell stopShake];
                        }
                    }
                }
            }
            break;
        case UIGestureRecognizerStateChanged:
            {
                //iOS9 方法 移动过程中随时更新cell位置
                [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:self.collectionView]];
            }
            break;
        case UIGestureRecognizerStateEnded:
            {
                //手势结束
                //iOS9方法 移动结束后关闭cell移动
                [self.collectionView endInteractiveMovement];
                
                _isItemShake = NO;
                NSArray *cellArray = [self.collectionView visibleCells];
                for (IMSFormImageControlsItemCell *cell in cellArray ) {
                    [cell stopShake];
                }
            }
            break;
        default:
        {
            [self.collectionView cancelInteractiveMovement];
            
            _isItemShake = NO;
            NSArray *cellArray = [self.collectionView visibleCells];
            for (IMSFormImageControlsItemCell *cell in cellArray ) {
                [cell stopShake];
            }
        }
            break;
    }
}

#pragma mark - Getters

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.layer.cornerRadius = 8.0;
        _collectionView.layer.masksToBounds = YES;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collectionView.scrollEnabled = NO;

        [_collectionView registerClass:[IMSFormImageControlsItemCell class] forCellWithReuseIdentifier:NSStringFromClass([IMSFormImageControlsItemCell class])];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
        longPress.minimumPressDuration = 0.5; // 设置长按响应时间为0.5秒
        [_collectionView addGestureRecognizer:longPress];
        
    }
    return _collectionView;
}

@end
