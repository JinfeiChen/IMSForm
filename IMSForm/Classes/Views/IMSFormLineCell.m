//
//  IMSFormLineCell.m
//  IMSForm
//
//  Created by cjf on 7/1/2021.
//

#import "IMSFormLineCell.h"

#import <IMSForm/IMSFormManager.h>

@interface IMSFormLineCell ()

@property (strong, nonatomic) UIView *lineView; /**< <#property#> */

@end

@implementation IMSFormLineCell

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
    [self.contentView addSubview:self.lineView];
    
    self.contentView.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.backgroundHexColor]);
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).with.insets(self.model.cpnStyle.contentInset);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Getters

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = IMS_HEXCOLOR(0xDDDDDD);
    }
    return _lineView;
}

@end
