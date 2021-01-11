//
//  IMSTagView.m
//  IMSForm
//
//  Created by cjf on 8/1/2021.
//

#import "IMSTagView.h"
#import <IMSForm/IMSTagFrame.h>

@implementation IMSTagViewUIModel

@end

@interface IMSTagView ()
@property (nonatomic, strong) NSMutableArray *viewArrayM;
@property (nonatomic, strong) NSMutableArray *labelArrayM;
@property (nonatomic, strong) IMSTagFrame *tagsFrame;
@property (nonatomic, assign) CGFloat supViewWidth;// 记录当前的width
@end

@implementation IMSTagView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)setDataUIModelArray:(NSArray<IMSTagViewUIModel *> *)dataUIModelArray {
    _dataUIModelArray = dataUIModelArray;
    
    self.tagsFrame.imageViewWith = self.deleteImage ? self.deleteImage.size.width : 0.0;
    NSMutableArray *textArrayM = [[NSMutableArray alloc]init];
    for (IMSTagViewUIModel *UIModel in dataUIModelArray) {
        [textArrayM addObject:UIModel.text];
    }
    self.tagsFrame.tagsArray = textArrayM;
    if (self.viewArrayM.count == textArrayM.count) {
        [self.viewArrayM enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel * label = self.labelArrayM[idx];
            label.text = textArrayM[idx];
            obj.frame = CGRectFromString(self.tagsFrame.tagsFrames[idx]);
        }];
        
        CGFloat height = self.tagSuperviewMinHeight > self.tagsFrame.tagsHeight ? self.tagSuperviewMinHeight : self.tagsFrame.tagsHeight;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        
        return;
    }else {
        [self.viewArrayM enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.viewArrayM removeAllObjects];
        [self.labelArrayM removeAllObjects];
    }
    
    [dataUIModelArray enumerateObjectsUsingBlock:^(IMSTagViewUIModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = obj.backgroudColor;
        bgView.layer.borderColor = obj.borderColor.CGColor;
        bgView.layer.borderWidth = obj.borderWidth;
        bgView.layer.masksToBounds = obj.masksToBounds;
        bgView.layer.cornerRadius = obj.cornerRadius;
        bgView.tag = idx;
        bgView.frame = CGRectFromString(self.tagsFrame.tagsFrames[idx]);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapViewAction:)];
        [bgView addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = obj.text;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = obj.textColor;
        label.font = self.tagItemfontSize;
        label.numberOfLines = 0;
        [bgView addSubview:label];
        
        if (self.deleteImage) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = self.deleteImage;
            [bgView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView);
                make.right.equalTo(bgView.mas_right).offset(-self.tagsMinPadding);
                make.size.mas_equalTo(self.deleteImage.size);
            }];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(bgView);
                make.left.mas_equalTo(bgView).offset(self.tagsMinPadding);
                make.right.equalTo(imageView.mas_left).offset(-self.contentPadding);
            }];
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(bgView);
                make.left.mas_equalTo(bgView).offset(self.tagsMinPadding);
                make.right.equalTo(bgView).offset(-self.tagsMinPadding);
            }];
        }
        [self addSubview:bgView];
        [self.labelArrayM addObject:label];
        [self.viewArrayM addObject:bgView];
    }];
    
    CGFloat height = self.tagSuperviewMinHeight > self.tagsFrame.tagsHeight ? self.tagSuperviewMinHeight : self.tagsFrame.tagsHeight;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}


- (void)setDataArray:(NSArray<NSString *> *)dataArray {
    _dataArray = dataArray;
    [self dealFrameMethod];
}

- (void)dealFrameMethod {
    
    self.tagsFrame.imageViewWith = self.deleteImage ? self.deleteImage.size.width : 0.0;
    
    self.tagsFrame.tagsArray = self.dataArray;
    
    if (self.viewArrayM.count == self.dataArray.count) {
        [self.viewArrayM enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel * label = self.labelArrayM[idx];
            label.text = self.dataArray[idx];
            obj.frame = CGRectFromString(self.tagsFrame.tagsFrames[idx]);
        }];
        
        CGFloat height = self.tagSuperviewMinHeight > self.tagsFrame.tagsHeight ? self.tagSuperviewMinHeight : self.tagsFrame.tagsHeight;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        return;
    }else {
        [self.viewArrayM enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.viewArrayM removeAllObjects];
        [self.labelArrayM removeAllObjects];
    }
    
    [self.dataArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = IMS_HEXCOLOR(0xE8EBF3);
        bgView.tag = idx;
        bgView.layer.cornerRadius = 2.0;
        bgView.layer.masksToBounds = YES;
        bgView.frame = CGRectFromString(self.tagsFrame.tagsFrames[idx]);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapViewAction:)];
        [bgView addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = obj;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = IMS_HEXCOLOR(0x5A6685);
        label.font = self.tagItemfontSize;
        label.numberOfLines = 0;
        [bgView addSubview:label];
        
        if (self.deleteImage) {
            
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = self.deleteImage;
            [bgView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView);
                make.right.equalTo(bgView.mas_right).offset(-self.tagsMinPadding);
                make.size.mas_equalTo(self.deleteImage.size);
            }];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(bgView);
                make.left.mas_equalTo(bgView).offset(self.tagsMinPadding);
                make.right.equalTo(imageView.mas_left).offset(-self.contentPadding);
            }];
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(bgView);
                make.left.mas_equalTo(bgView).offset(self.tagsMinPadding);
                make.right.equalTo(bgView).offset(-self.tagsMinPadding);
            }];
        }
        [self addSubview:bgView];
        [self.labelArrayM addObject:label];
        [self.viewArrayM addObject:bgView];
    }];
    
    CGFloat height = self.tagSuperviewMinHeight > self.tagsFrame.tagsHeight ? self.tagSuperviewMinHeight : self.tagsFrame.tagsHeight;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

#pragma mark - tapaction
- (void)viewTapViewAction:(UIGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(tagView:didSelectAtIndex:)]) {
        [self.delegate tagView:self didSelectAtIndex:tap.view.tag];
    }
}

#pragma mark - lazy load
- (NSMutableArray *)viewArrayM {
    if (_viewArrayM == nil) {
        _viewArrayM = [[NSMutableArray alloc] init];
    }
    return _viewArrayM;
}

- (NSMutableArray *)labelArrayM {
    if (_labelArrayM == nil) {
        _labelArrayM = [[NSMutableArray alloc] init];
    }
    return _labelArrayM;
}

- (IMSTagFrame *)tagsFrame {
    if (_tagsFrame == nil) {
        _tagsFrame = [[IMSTagFrame alloc] init];
        _tagsFrame.minimumInteritemSpacing = self.minimumInteritemSpacing;
        _tagsFrame.minimumLineSpacing = self.minimumLineSpacing;
        _tagsFrame.tagItemfontSize = self.tagItemfontSize;
        _tagsFrame.tagsMinPadding = self.tagsMinPadding;
        _tagsFrame.tagItemHeight = self.tagItemHeight;
        _tagsFrame.contentInset = self.contentInset;
        _tagsFrame.tagSuperviewWidth = self.tagSuperviewWidth;
        _tagsFrame.contentPadding = self.contentPadding;
    }
    return _tagsFrame;
}

@end
