//
//  IMSFormTextFieldCell.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormTextFieldCell.h"

@implementation IMSFormTextFieldCell

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
    [self.bodyView addSubview:self.textField];
    
    CGFloat spacing = self.model.cpnConfig.style.spacing;
    if (self.model.cpnConfig.style.layout == IMSFormComponentLayout_Horizontal) {
        
    } else {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(self.model.cpnConfig.style.contentInset.top);
            make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnConfig.style.contentInset.left);
            make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnConfig.style.contentInset.right);
        }];
        [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(spacing);
            make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnConfig.style.contentInset.left);
            make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnConfig.style.contentInset.right);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnConfig.style.contentInset.bottom);
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bodyView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.height.mas_equalTo(kIMSFormDefaultHeight);
        }];
    }
}

#pragma mark - Getters

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = self.model.placeholder;
    }
    return _textField;
}

@end
