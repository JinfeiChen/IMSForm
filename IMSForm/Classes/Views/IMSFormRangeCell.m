//
//  IMSFormRangeCell.m
//  IMSForm
//
//  Created by cjf on 6/1/2021.
//

#import "IMSFormRangeCell.h"

#import <IMSForm/IMSFormManager.h>

@interface IMSFormRangeCell () <UITextFieldDelegate>

@property (copy, nonatomic) NSString *minValue; /**< <#property#> */
@property (copy, nonatomic) NSString *maxValue; /**< <#property#> */

@end

@implementation IMSFormRangeCell

@synthesize model = _model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _minValue = @"";
        _maxValue = @"";
        [self buildView];
        
        __weak __typeof__(self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
            __typeof__(self) strongSelf = weakSelf;
            if (note.object == strongSelf.minTextField || note.object == strongSelf.maxTextField) {
                // call back
                if (strongSelf.didUpdateFormModelBlock) {
                    strongSelf.didUpdateFormModelBlock(strongSelf, strongSelf.model, nil);
                }
            }
        }];
    }
    return self;
}

#pragma mark - UI

- (void)buildView
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.lineLabel];
    [self.bodyView addSubview:self.minTextField];
    [self.bodyView addSubview:self.maxTextField];
    
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
    
    self.minTextField.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    self.maxTextField.backgroundColor = self.minTextField.backgroundColor;
    
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
            make.left.mas_equalTo(self.contentView).mas_offset(self.model.cpnStyle.contentInset.left);
            make.right.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.right);
            make.height.mas_equalTo(kIMSFormDefaultHeight);
        }];
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];
    }

    [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(8);
        make.center.equalTo(self.bodyView);
    }];
    [self.minTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.bodyView).offset(0);
        make.right.mas_equalTo(self.lineLabel.mas_left).offset(-spacing);
    }];
    [self.maxTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.bodyView).offset(0);
        make.left.mas_equalTo(self.lineLabel.mas_right).offset(spacing);
    }];
}

#pragma mark - Private Methods

// 清除重用数据
- (void)clearReuseData
{
    self.titleLabel.text = @"";
    self.infoLabel.text = @"";
    self.minTextField.text = @"";
    self.minTextField.placeholder = @"Please enter";
    self.minValue = @"";
    self.maxTextField.text = @"";
    self.maxTextField.placeholder = @"Please enter";
    self.maxValue = @"";
}

#pragma mark - Public Methods

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self clearReuseData];
    [self setTitle:model.title required:model.isRequired];
    
    CGFloat minValue = MAX(CGFLOAT_MIN, self.model.cpnConfig.min);
    CGFloat maxValue = MIN(CGFLOAT_MAX, self.model.cpnConfig.max);
    if (model.value && [model.value containsString:@";"]) {
        NSArray *valueArr = [model.value componentsSeparatedByString:@";"];
        minValue = [valueArr.firstObject floatValue];
        maxValue = [valueArr.lastObject floatValue];
    }
    
    minValue = MAX(minValue, self.model.cpnConfig.min);
    minValue = MIN(minValue, self.model.cpnConfig.max);
    self.minTextField.text = [NSString getRoundFloat:minValue withPrecisionNum:self.model.cpnConfig.precision];
    self.minTextField.placeholder = self.model.cpnConfig.minPlaceholder ? : @"Please enter";
    self.minValue = self.minTextField.text;
    
    maxValue = MAX(maxValue, self.model.cpnConfig.min);
    maxValue = MIN(maxValue, self.model.cpnConfig.max);
    self.maxTextField.text = [NSString getRoundFloat:maxValue withPrecisionNum:self.model.cpnConfig.precision];
    self.maxTextField.placeholder = self.model.cpnConfig.maxPlaceholder ? : @"Please enter";
    self.maxValue = self.maxTextField.text;
    
    self.infoLabel.text = model.info;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!self.model.isEditable) {
        return NO;
    }

    // number limit
//        if (![IMSFormValidateManager isNumber:string]) {
//            return NO;
//        }

    BOOL returnKey = [string rangeOfString:@"\n"].location != NSNotFound;
    
    // update model value
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 100) { // min
        _minValue = [NSString getRoundFloat:[str floatValue] withPrecisionNum:self.model.cpnConfig.precision];
    } else if (textField.tag == 101) { // max
        _maxValue = [NSString getRoundFloat:[str floatValue] withPrecisionNum:self.model.cpnConfig.precision];
    }
    self.model.value = [@[_minValue, _maxValue] componentsJoinedByString:@";"];

    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }

    return ([str floatValue] >= self.model.cpnConfig.min && [str floatValue] <= self.model.cpnConfig.max) || returnKey;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    // update textField value
    if (textField.tag == 100) { // min
        textField.text = _minValue;
    } else if (textField.tag == 101) { // max
        textField.text = _maxValue;
    }
    
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
    
    // update model value
    if (textField.tag == 100) { // min
        self.minValue = @"";
    } else if (textField.tag == 101) { // max
        self.maxValue = @"";
    }
    self.model.value = [@[_minValue, _maxValue] componentsJoinedByString:@";"];
    
    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }
    
    return YES;
}

#pragma mark - Getters

- (UILabel *)lineLabel {
    if (_lineLabel == nil) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.text = @"-";
    }
    return _lineLabel;
}

- (UITextField *)minTextField {
    if (_minTextField == nil) {
        _minTextField = [[UITextField alloc] init];
        _minTextField.tag = 100;
        _minTextField.font = [UIFont systemFontOfSize:12];
        _minTextField.textColor = IMS_HEXCOLOR(0x565465);
        _minTextField.tintColor = IMS_HEXCOLOR(0x184585);
        _minTextField.delegate = self;
        _minTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _minTextField.returnKeyType = UIReturnKeyDone;
        _minTextField.backgroundColor = [UIColor whiteColor];
        _minTextField.textAlignment = NSTextAlignmentCenter;
        _minTextField.layer.cornerRadius = 8.0;
        _minTextField.layer.masksToBounds = YES;
        _minTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _minTextField;
}

- (UITextField *)maxTextField {
    if (_maxTextField == nil) {
        _maxTextField = [[UITextField alloc] init];
        _maxTextField.tag = 101;
        _maxTextField.font = [UIFont systemFontOfSize:12];
        _maxTextField.textColor = IMS_HEXCOLOR(0x565465);
        _maxTextField.tintColor = IMS_HEXCOLOR(0x184585);
        _maxTextField.delegate = self;
        _maxTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _maxTextField.returnKeyType = UIReturnKeyDone;
        _maxTextField.backgroundColor = [UIColor whiteColor];
        _maxTextField.textAlignment = NSTextAlignmentCenter;
        _maxTextField.layer.cornerRadius = 8.0;
        _maxTextField.layer.masksToBounds = YES;
        _maxTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _maxTextField;
}

@end
