//
//  IMSFormInputTagCell.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/2/2.
//

#import "IMSFormInputTagCell.h"
#import "IMSTagView.h"

@interface IMSFormInputTagCell ()<UITextFieldDelegate,IMSTagViewDelegate>
@property (strong, nonatomic) UITextField *textField; /**< <#property#> */
@property (nonatomic, strong) IMSTagView *tagView;
@property (nonatomic, strong) NSMutableArray *valueListM;
@end

@implementation IMSFormInputTagCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
//        [self.bodyView addGestureRecognizer:tap];
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
    [self.bodyView addSubview:self.tagView];
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
    self.bodyView.userInteractionEnabled = self.model.isEditable;
    self.bodyView.backgroundColor = self.model.isEditable ? kEnabledCellBodyBackgroundColor : kDisabledCellBodyBackgroundColor;
    self.tagView.tintColor = IMS_HEXCOLOR([NSString intRGBWithHex:self.model.cpnStyle.tintHexColor]);
    
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
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bodyView).offset(5);
        make.left.equalTo(self.bodyView).offset(10);
        make.right.equalTo(self.bodyView);
        make.height.mas_equalTo(30);
    }];
    
    self.tagView.tagSuperviewWidth = [UIScreen mainScreen].bounds.size.width - self.model.cpnStyle.contentInset.left - self.model.cpnStyle.contentInset.right;
    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom);
        make.right.left.bottom.equalTo(self.bodyView);
    }];
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bodyView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.bodyView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-self.model.cpnStyle.contentInset.bottom);
    }];
}

- (void)setModel:(IMSFormModel *)model form:(nonnull IMSFormManager *)form
{
    [super setModel:model form:form];
    
    [self updateUI];
    
    [self setTitle:model.title required:model.isRequired];
    
    self.infoLabel.text = model.info;
    
    // 默认值
    [model.valueList removeAllObjects];
    for (IMSFormSelect *selectModel in model.cpnConfig.dataSource) {
        if (selectModel.selected) {
            [model.valueList addObject:[selectModel yy_modelToJSONObject]];
        }
    }
    
    self.valueListM = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:self.model.valueList].mutableCopy;

    [self updateTagViewDataSource];

}

#pragma mark - Private Methods
- (void)updateTagViewDataSource {
    
    NSMutableArray *titleArrayM = [NSMutableArray array];
    for (IMSFormSelect *model in  self.valueListM) {
        [titleArrayM addObject:model.label ?: (model.value ?: @"N/A")];
    }
    self.tagView.dataArray = titleArrayM;
}

#pragma mark -textFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason  API_AVAILABLE(ios(10.0)) {
    textField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self keyboardReturn:textField];
    return YES;
}

- (void)keyboardReturn:(UITextField *)textField {
    if (textField.text.length == 0) return;
    for (IMSFormSelect *model in self.valueListM) {
        if ([textField.text.lowercaseString isEqualToString:model.label.lowercaseString])  {
             textField.text = @"";
             return;
        }
    }
    
    IMSFormSelect *addModel = [[IMSFormSelect alloc]init];
    addModel.label = addModel.value = textField.text;
    [self.valueListM addObject:addModel];
    self.model.valueList = [self.valueListM yy_modelToJSONObject];
    
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
    [self updateTagViewDataSource];
    
    textField.text = @"";
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
}

#pragma mark - RATagViewDelegate
- (void)tagView:(IMSTagView *)tagView didSelectAtIndex:(NSInteger)index {
    
    // delete
    [self.valueListM removeObjectAtIndex:index];
    self.model.valueList = [self.valueListM yy_modelToJSONObject];

    [self updateTagViewDataSource];
    
    if (self.didUpdateFormModelBlock) {
        self.didUpdateFormModelBlock(self, self.model, nil);
    }
    
    [self.form.tableView beginUpdates];
    [self.form.tableView endUpdates];
}

#pragma mark - lazy load
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"Please enter";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:12];
    }
    return _textField;
}

- (IMSTagView *)tagView {
    if (_tagView == nil) {
        _tagView = [[IMSTagView alloc] init];
        _tagView.minimumLineSpacing = 5;
        _tagView.tagsMinPadding = 10;
        _tagView.minimumInteritemSpacing = 5;
        _tagView.tagItemfontSize = [UIFont systemFontOfSize:12];
        _tagView.tagItemHeight = 25.0;
        _tagView.contentInset = UIEdgeInsetsMake(0, 10, 5, 0);
        _tagView.contentPadding = 5.0;
        _tagView.tagSuperviewMinHeight = 0.0;
        _tagView.deleteImage = [UIImage bundleImageWithNamed:@"search_close_tag"];
        _tagView.delegate = self;
    }
    return _tagView;
}

- (NSMutableArray *)valueListM {
    if (_valueListM == nil) {
        _valueListM = [[NSMutableArray alloc] init];
    }
    return _valueListM;
}

@end
