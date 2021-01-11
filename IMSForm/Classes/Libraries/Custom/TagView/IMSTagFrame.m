//
//  IMSTagFrame.m
//  IMSForm
//
//  Created by cjf on 8/1/2021.
//
//  计算多个标签的位置
//  标签根据文字自适应宽度
//  每行超过的宽度平均分配给每个标签
//  每行标签左右对其

#import "IMSTagFrame.h"

@implementation IMSTagFrame

- (id)init {
    self = [super init];
    if (self) {
        _tagsFrames = [NSMutableArray array];
        _tagsMinPadding = 10;
        _minimumLineSpacing = 10;
        _minimumInteritemSpacing = 10;
        _tagItemfontSize = [UIFont systemFontOfSize:12];
        _tagItemHeight = 20.0;
        _contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tagSuperviewWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return self;
}

// 重新定义
- (void)setTagsArray:(NSArray *)tagsArray {
    
    _tagsArray = tagsArray;
    
    [_tagsFrames removeAllObjects];
    
    CGFloat btnX = _contentInset.left;
    CGFloat btnW = 0;
    
    CGFloat nextWidth = 0;  // 下一个标签的宽度
    CGFloat moreWidth = 0;  // 每一行多出来的宽度
    
    /**
     *  每一行的最后一个tag的索引的数组和每一行多出来的宽度的数组
     */
    NSMutableArray *lastIndexs = [NSMutableArray array];// 有多少行。
    NSMutableArray *moreWidths = [NSMutableArray array];
    
    for (NSInteger i = 0; i < tagsArray.count; i++) {
        
        btnW = [self tagItemWidth:tagsArray[i]];
        
        if (i < tagsArray.count - 1) {
            nextWidth = [self tagItemWidth:tagsArray[i+1]];
        }
        
        CGFloat nextBtnX = btnX + btnW + _minimumInteritemSpacing;
        
        // 如果下一个按钮，标签最右边超出则换行
        if ((nextBtnX + nextWidth) > (self.tagSuperviewWidth - _contentInset.right)) {
            // 计算超过的宽度
            moreWidth = self.tagSuperviewWidth - nextBtnX - _contentInset.right + _minimumInteritemSpacing;
            
            [lastIndexs addObject:[NSNumber numberWithInteger:i]];
            [moreWidths addObject:[NSNumber numberWithFloat:moreWidth]];
            btnX = _contentInset.left;
        }else {
            btnX += (btnW + _minimumInteritemSpacing);
        }
        
        // 如果是最后一个且数组中没有，则把最后一个加入数组
        if (i == tagsArray.count - 1) {
            if (![lastIndexs containsObject:[NSNumber numberWithInteger:i]]) {
                [lastIndexs addObject:[NSNumber numberWithInteger:i]];
                [moreWidths addObject:[NSNumber numberWithFloat:0]];
            }
        }
    }
    
    NSInteger location = 0;  // 截取的位置
    NSInteger length = 0;    // 截取的长度
    CGFloat averageW = 0;    // 多出来的平均的宽度，正数不计算，负数计算
//    _tagsHeight =  _contentInset.top + _contentInset.bottom;
    
    CGFloat tagW = 0;
    //item的高度
    CGFloat tagH = self.tagItemHeight;
    
    for (NSInteger i = 0; i < lastIndexs.count; i++) {
        
        NSInteger lastIndex = [lastIndexs[i] integerValue];
        
        if (i == 0) {
            length = lastIndex + 1;
        }else {
            length = [lastIndexs[i] integerValue] - [lastIndexs[i-1] integerValue];
        }
        
        // 从数组中截取每一行的数组
        NSArray *newArr = [tagsArray subarrayWithRange:NSMakeRange(location, length)];
        location = lastIndex + 1;
        averageW = [moreWidths[i] floatValue] / newArr.count;// 平均宽度，正数不计算，负数计算
        // 重置一下
        averageW = averageW < 0 ? averageW : 0;
        
        CGFloat tagX = _contentInset.left;
        CGRect lastFrame =  CGRectFromString(_tagsFrames.lastObject);
        CGFloat tagY = CGRectGetMaxY(lastFrame) + _minimumLineSpacing;
        if (CGRectEqualToRect(lastFrame, CGRectZero)) {// 说明是第一行
            tagY = _contentInset.top;
        }
        // 根据行来分批 布局frame。。
        for (NSInteger j = 0; j < newArr.count; j++) {
            
            tagW = [self tagItemWidth:newArr[j]] + averageW;
            
            if (self.tagSuperviewWidth - self.contentInset.left - self.contentInset.right - tagW < 0.5) { // 把误差精确到0.5之间
                // 算出text的高度
                CGFloat topBottomMagirn = self.tagItemHeight - ceilf([self sizeWithText:newArr[j] font:self.tagItemfontSize].height);
                
                tagH  =  [self tagsItemHeight:newArr[j] andWidth:tagW - self.contentInset.left - self.contentInset.right - self.tagsMinPadding*2.0 - self.contentPadding - self.imageViewWith] + topBottomMagirn;
            }else {
                tagH = self.tagItemHeight;
            }
            CGRect btnF = CGRectMake(tagX, tagY, tagW, tagH);
            
            [_tagsFrames addObject:NSStringFromCGRect(btnF)];
            
            tagX += (tagW+_minimumInteritemSpacing);
        }
    }
    
    //获取总高度， 思路，取最后一个控件，获取最大的frame 加上contentInset.top 和contentInset.bottom；
    CGRect lastFrame =  CGRectFromString(_tagsFrames.lastObject);
    _tagsHeight = CGRectGetMaxY(lastFrame) +  _contentInset.bottom;
    if (_tagsHeight < 0) _tagsHeight = 0;
    
}

#pragma mark - privacy
- (CGFloat)tagItemWidth:(NSString *)text {
    CGFloat width = ceilf([self sizeWithText:text font:self.tagItemfontSize].width)+0.5;
    return width + self.tagsMinPadding * 2.0 + self.imageViewWith + self.contentPadding;
}

- (CGFloat)tagsItemHeight:(NSString *)text andWidth:(CGFloat)width{
    
    NSDictionary *attribute = @{NSFontAttributeName: self.tagItemfontSize};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGFloat height = ceilf(size.height);
    return height;
}

/**
 *  单行文本数据获取宽高
 *
 *  @param text 文本
 *  @param font 字体
 *
 *  @return 宽高
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName :font};
    return [text sizeWithAttributes:attrs];
}

@end
