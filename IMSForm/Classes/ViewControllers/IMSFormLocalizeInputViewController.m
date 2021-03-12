//
//  IMSFormLocalizeInputViewController.m
//  IMSForm
//
//  Created by cjf on 12/3/2021.
//

#import "IMSFormLocalizeInputViewController.h"
#import <Masonry/Masonry.h>
#import <YYText/YYTextView.h>

typedef NS_ENUM(NSUInteger, IMSFormInputType) {
    IMSFormInputType_TextField,
    IMSFormInputType_TextView,
};

@interface IMSFormLocalizeInputTableViewCell : UITableViewCell <YYTextViewDelegate, UITextFieldDelegate>

@property (assign, nonatomic) IMSFormInputType inputType; /**< <#property#> */
@property (strong, nonatomic) UILabel *titleLabel; /**< <#property#> */
@property (strong, nonatomic) UITextField *textField; /**< <#property#> */
@property (strong, nonatomic) YYTextView *textView; /**< <#property#> */

@property (copy, nonatomic) void(^didEndEditingBlock)(NSDictionary *result); /**< <#property#> */

@end

@implementation IMSFormLocalizeInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildView];
    }
    return self;
}

- (void)buildView
{
    
}

- (void)setInputType:(IMSFormInputType)inputType
{
    _inputType = inputType;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:self.titleLabel];
    
    BOOL isTextField = inputType == IMSFormInputType_TextField;
    if (isTextField) {
        [self.contentView addSubview:self.textField];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(5);
            make.bottom.mas_equalTo(self.contentView).offset(-5);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(44);
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(5);
            make.bottom.mas_equalTo(self.contentView).offset(-5);
            make.left.mas_equalTo(self.contentView).offset(15);
            make.right.mas_equalTo(self.textField.mas_left).offset(10);
            make.width.mas_equalTo(120);
        }];
    } else {
        [self.contentView addSubview:self.textView];
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(5);
            make.bottom.mas_equalTo(self.contentView).offset(-5);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(100);
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(5);
            make.bottom.mas_equalTo(self.contentView).offset(-5);
            make.left.mas_equalTo(self.contentView).offset(15);
            make.right.mas_equalTo(self.textView.mas_left).offset(10);
            make.width.mas_equalTo(120);
        }];
    }
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.didEndEditingBlock) {
        self.didEndEditingBlock(@{
            self.titleLabel.text : textField.text
                                });
    }
}

#pragma mark - YYTextViewDelegate

- (void)textViewDidEndEditing:(YYTextView *)textView
{
    if (self.didEndEditingBlock) {
        self.didEndEditingBlock(@{
            self.titleLabel.text : textView.text
                                });
    }
}

@end

@interface IMSFormLocalizeInputViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIButton *confirmButton; /**< <#property#> */
@property (strong, nonatomic) UITableView *tableView; /**< <#property#> */

@property (strong, nonatomic) NSMutableArray *outputDataSource; /**< <#property#> */

@end

@implementation IMSFormLocalizeInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.confirmButton];
    
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.bottom.right.mas_equalTo(self.view).offset(0);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view).offset(0);
        make.bottom.mas_equalTo(self.confirmButton.mas_top).offset(0);
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([IMSFormLocalizeInputTableViewCell class]);
    IMSFormLocalizeInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[IMSFormLocalizeInputTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier];
    }
    cell.inputType = IMSFormInputType_TextField;
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", dict.allKeys.firstObject];
    cell.textField.text = [NSString stringWithFormat:@"%@", dict.allValues.firstObject];
    cell.textView.text = [NSString stringWithFormat:@"%@", dict.allValues.firstObject];
    cell.didEndEditingBlock = ^(NSDictionary *result) {
        if (result) {
            [self.outputDataSource replaceObjectAtIndex:indexPath.row withObject:result];
        }
    };
    return cell;
}

#pragma mark - Actions

- (void)confirmButtonAction:(id)sender
{
    if (self.saveBlock) {
        self.saveBlock(self.outputDataSource);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setters

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    self.outputDataSource = [NSMutableArray arrayWithArray:dataSource];
}

#pragma mark - Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[IMSFormLocalizeInputTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IMSFormLocalizeInputTableViewCell class])];
    }
    return _tableView;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:194/255.0 blue:76/255.0 alpha:1.0]];
        [_confirmButton setTitle:@"Save" forState:UIControlStateNormal];
    }
    return _confirmButton;
}

@end
