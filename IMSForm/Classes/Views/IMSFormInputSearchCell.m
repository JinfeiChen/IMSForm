//
//  IMSFormInputSearchCell.m
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import "IMSFormInputSearchCell.h"
#import <IMSForm/IMSFormManager.h>
#import <IMSForm/IMSPopupSingleSelectListView.h>

@interface IMSFormInputSearchCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *searchView;
@property (strong, nonatomic) IMSPopupSingleSelectListView *singleSelectListView; /**< <#property#> */

@end

@implementation IMSFormInputSearchCell

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
    if ([self.model.cpnStyle.layout isEqualToString:IMSFormLayoutType_Horizontal]) {
        self.bodyView.backgroundColor = [UIColor whiteColor];
        
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
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bodyView).with.insets(UIEdgeInsetsMake(0, 10, 0, 0));
            make.height.mas_equalTo(kIMSFormDefaultHeight);
        }];
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];
    } else {
        self.bodyView.backgroundColor = [UIColor whiteColor];
        
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
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bodyView).with.insets(UIEdgeInsetsMake(0, 10, 0, 0));
            make.height.mas_equalTo(kIMSFormDefaultHeight);
        }];
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
            make.left.right.mas_equalTo(self.bodyView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
        }];
    }
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!self.model.isEditable) {
        return NO;
    }
    
    // length limit
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    // update model value
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.model.value = str;
    
    // call back
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
    // text type limit, change 触发校验
    if ([self.model.cpnRule.trigger isEqualToString:IMSFormTrigger_Change]) {
        [self validate];
    }
    
    return newLength <= self.self.model.cpnConfig.lengthLimit || returnKey;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {

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
    
    self.textField.text = [model.value substringWithRange:NSMakeRange(0, MIN(model.value.length, self.model.cpnConfig.lengthLimit))];
    self.textField.placeholder = model.placeholder ? : @"Please enter";
    
    self.infoLabel.text = model.info;
    
    self.bodyView.userInteractionEnabled = model.isEditable;
    
    if (model.isEditable) {
        self.textField.keyboardType = [self keyboardWithTextType:self.model.cpnConfig.textType];
        self.textField.secureTextEntry = [self.model.cpnConfig.textType isEqualToString:IMSFormTextType_Password];
    }
}

#pragma mark - Actions

- (void)searchButtonAction:(UIButton *)sender
{
    if (self.textField.text.length <= 0) {
        NSLog(@"please input some text first");
        [IMSDropHUD showAlertWithType:IMSFormMessageType_Warning message:@"please input some text first"];
        return;
    }
    
    self.model.value = self.textField.text;
    
//    // call back
//    if (self.didUpdateFormModelBlock) {
//        self.didUpdateFormModelBlock(self, self.model, nil);
//    }
    
    if (self.form) {
        if (self.form.delegate && [self.form.delegate respondsToSelector:NSSelectorFromString(@"testInputSearchWithFormModel:completation:")]) {
            [self.form.delegate testInputSearchWithFormModel:self.model completation:^(NSArray * _Nonnull dataArray) {
                
            }];
        }
    }
}

#pragma mark - Getters

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"Please enter";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.returnKeyType = UIReturnKeySearch;
        
//        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
//        leftView.backgroundColor = [UIColor clearColor];
//        _textField.leftView = leftView;
//        _textField.leftViewMode = UITextFieldViewModeAlways;

        _textField.rightView = self.searchView;
        _textField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (UIView *)searchView {
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        _searchView.backgroundColor = [UIColor colorWithRed:255/255.0 green:194/255.0 blue:76/255.0 alpha:1.0];
        UIButton *rightButton = [[UIButton alloc]initWithFrame:_searchView.bounds];
        [rightButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage bundleImageWithNamed:@"search"] forState:UIControlStateNormal];
        [_searchView addSubview:rightButton];
    }
    return _searchView;
}

- (IMSPopupSingleSelectListView *)singleSelectListView {
    if (_singleSelectListView == nil) {
        _singleSelectListView = [[IMSPopupSingleSelectListView alloc] initWithFrame:CGRectZero];
    }
    return _singleSelectListView;
}

@end
