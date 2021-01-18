//
//  IMSFormNumberCell.m
//  IMSForm
//
//  Created by cjf on 6/1/2021.
//

#import "IMSFormNumberCell.h"

#import <IMSForm/IMSFormManager.h>
#import <IMSForm/NSString+Extension.h>

@interface IMSFormNumberCell () <UITextFieldDelegate>

@end

@implementation IMSFormNumberCell

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
    [self.bodyView addSubview:self.textField];
    [self.bodyView addSubview:self.decreaseButton];
    [self.bodyView addSubview:self.increaseButton];
    
    [self updateUI];
}

- (void)updateUI
{
    self.contentView.backgroundColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.backgroundHexColor]);

    self.titleLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.titleHexColor]);
    self.titleLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.titleFontSize weight:UIFontWeightMedium];

    self.infoLabel.font = [UIFont systemFontOfSize:self.model.cpnStyle.infoFontSize weight:UIFontWeightRegular];
    self.infoLabel.textColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.infoHexColor]);
    
    self.bodyView.backgroundColor = self.contentView.backgroundColor;
    self.bodyView.userInteractionEnabled = self.model.isEditable;
    
    self.textField.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    self.decreaseButton.backgroundColor = self.textField.backgroundColor;
    self.increaseButton.backgroundColor = self.textField.backgroundColor;

    CGFloat spacing = self.model.cpnStyle.spacing;
    if ([self.model.cpnStyle.layout isEqualToString:IMSFormLayoutType_Horizontal]) {
        [self.bodyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(spacing);
            make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
            make.height.mas_equalTo(kIMSFormDefaultHeight);
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.top + 8);
            make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
            make.right.mas_equalTo(self.bodyView.mas_left).mas_offset(-self.model.cpnStyle.spacing);
            make.width.mas_lessThanOrEqualTo(150);
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
            make.left.equalTo(self.contentView).offset(self.model.cpnStyle.contentInset.left);
            make.right.equalTo(self.contentView).offset(-self.model.cpnStyle.contentInset.right);
            make.height.mas_equalTo(kIMSFormDefaultHeight);
        }];
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];
    }

    [self.decreaseButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.bodyView);
        make.centerY.equalTo(self.bodyView);
    }];
    [self.increaseButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(self.bodyView);
        make.centerY.equalTo(self.bodyView);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bodyView);
        make.left.mas_equalTo(self.decreaseButton.mas_right).offset(10);
        make.right.mas_equalTo(self.increaseButton.mas_left).offset(-10);
    }];

//    [self.form.tableView beginUpdates];
//    [self.form.tableView endUpdates];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!self.model.isEditable) {
        return NO;
    }

    // number limit
//    if (![IMSFormValidateManager isNumber:string]) {
//        return NO;
//    }

    BOOL returnKey = [string rangeOfString:@"\n"].location != NSNotFound;

    // update model value
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.model.value = [NSString getRoundFloat:[str floatValue] withPrecisionNum:self.model.cpnConfig.precision];

    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }

    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }

    return ([str floatValue] >= self.model.cpnConfig.min && [str floatValue] <= self.model.cpnConfig.max) || returnKey;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    // update textField value
    textField.text = self.model.value;
    
    // text type limit, blur 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Blur]) {
        [self validate];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.model.value = @"";

    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }

    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }

    return YES;
}

#pragma mark - Private Methods

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];

    [self updateUI];

    [self setTitle:model.title required:model.isRequired];

    self.infoLabel.text = model.info;

    CGFloat value = MAX(model.value.floatValue, self.model.cpnConfig.min);
    value = MIN(value, self.model.cpnConfig.max);
    self.textField.text = [NSString getRoundFloat:value withPrecisionNum:self.model.cpnConfig.precision];
}

#pragma mark - Actions

- (void)decreaseButtonAction:(UIButton *)button
{
    CGFloat current = [self.textField.text floatValue];
    CGFloat result = MAX((current - self.model.cpnConfig.increment), self.model.cpnConfig.min);
    self.textField.text = [NSString getRoundFloat:result withPrecisionNum:self.model.cpnConfig.precision];

    // update model value
    self.model.value = self.textField.text;

    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }

    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }
}

- (void)increaseButtonAction:(UIButton *)button
{
    CGFloat current = [self.textField.text floatValue];
    CGFloat result = MIN((current + self.model.cpnConfig.increment), self.model.cpnConfig.max);
    self.textField.text = [NSString getRoundFloat:result withPrecisionNum:self.model.cpnConfig.precision];

    // update model value
    self.model.value = self.textField.text;

    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }

    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }
}

#pragma mark - Getters

- (UIButton *)decreaseButton
{
    if (!_decreaseButton) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"-" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(decreaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.layer.cornerRadius = 8.0;
        button.layer.masksToBounds = YES;
        _decreaseButton = button;
    }
    return _decreaseButton;
}

- (UIButton *)increaseButton
{
    if (!_increaseButton) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"+" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(increaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.layer.cornerRadius = 8.0;
        button.layer.masksToBounds = YES;
        _increaseButton = button;
    }
    return _increaseButton;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = IMS_HEXCOLOR(0x565465);
        _textField.layer.masksToBounds = YES;
        _textField.layer.cornerRadius = 8;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;

        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        leftView.backgroundColor = [UIColor clearColor];
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

@end
