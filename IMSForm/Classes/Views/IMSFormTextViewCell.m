//
//  IMSFormTextViewCell.m
//  IMSForm
//
//  Created by cjf on 6/1/2021.
//

#import "IMSFormTextViewCell.h"
#import <IMSForm/IMSFormManager.h>

@interface IMSFormTextViewCell () <YYTextViewDelegate>

@end

@implementation IMSFormTextViewCell

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
    [self.bodyView addSubview:self.textView];
    
    [self updateUI];
}

- (void)updateUI
{
    self.contentView.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.backgroundHexColor]);
    
    self.titleLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.titleHexColor]);
    self.titleLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.titleFontSize weight:UIFontWeightMedium];
    
    self.infoLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.infoFontSize weight:UIFontWeightRegular];
    self.infoLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.infoHexColor]);
    
    self.bodyView.userInteractionEnabled = self.model.isEditable;
    self.bodyView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    self.textView.backgroundColor = self.bodyView.backgroundColor;
    
    if (self.model.isEditable) {
        self.textView.keyboardType = [self keyboardWithTextType:self.model.cpnConfig.textType];
        self.textView.secureTextEntry = [self.model.cpnConfig.textType isEqualToString:IMSFormTextType_Password];
    }
    
    CGFloat spacing = self.model.cpnStyle.spacing;
    if ([self.model.cpnStyle.layout isEqualToString:IMSFormLayoutType_Horizontal]) {
        
        [self.bodyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(spacing);
            make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.top + 8);
            make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
            make.right.mas_equalTo(self.bodyView.mas_left).mas_offset(-self.model.cpnStyle.spacing);
            make.width.mas_lessThanOrEqualTo(150);
        }];
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bodyView).with.insets(UIEdgeInsetsMake(0, 10, 0, 10));
            make.height.mas_equalTo(100);
        }];
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];
    } else {
        
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
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bodyView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.height.mas_equalTo(100);
        }];
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];
    }
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self clearReuseData];
    [self setTitle:model.title required:model.isRequired];
    
    // update default value
    NSRange range = NSMakeRange(0, MIN(model.value.length, self.model.cpnConfig.lengthLimit));
    self.textView.text = [model.value substringWithRange:range];
    
    self.textView.placeholderText = model.placeholder ? : @"Please enter";
    
    self.infoLabel.text = model.info;
}

#pragma mark - Private Methods

// 清除重用数据
- (void)clearReuseData
{
    self.titleLabel.text = @"";
    self.infoLabel.text = @"";
    self.textView.text = @"";
    self.textView.placeholderText = @"Please enter";
}

#pragma mark - YYTextViewDelegate

- (void)textViewDidEndEditing:(YYTextView *)textView {
    self.model.value = textView.text;
    
    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
    // text type limit, blur 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Blur]) {
        [self validate];
    }
}

//- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (!self.model.isEditable) {
//        return NO;
//    }
//    
//    if (![textView isFirstResponder]) {
//        return NO;
//    }
//    
//    // length limit
//    NSUInteger oldLength = [textView.text length];
//    NSUInteger replacementLength = [text length];
//    NSUInteger rangeLength = range.length;
//    NSUInteger newLength = oldLength - rangeLength + replacementLength;
//    BOOL returnKey = [text rangeOfString: @"\n"].location != NSNotFound;
//    
//    // update model value
//    if (textView.text && textView.text.length > 0) {
//        NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
//        self.model.value = str;
//    }
//    
//    // text type limit, change 触发校验
//    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
//        [self validate];
//    }
//    
//    // 回车结束编辑
////    if ([text isEqualToString:@"\n"]) {
////        [textView resignFirstResponder];
////        return NO;
////    }
//    return newLength <= self.model.cpnConfig.lengthLimit || returnKey;
//}

#pragma mark - Getters

- (YYTextView *)textView {
    if (_textView == nil) {
        _textView = [[YYTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.textColor = IMS_HEXCOLOR(0x565465);
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius  = 8;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
        _textView.placeholderText = @"Please enter";
    }
    return _textView;
}

@end
