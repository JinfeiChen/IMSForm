//
//  IMSViewController.m
//  IMSForm
//
//  Created by jinfei_chen@.com on 12/30/2020.
//  Copyright (c) 2020 jinfei_chen@icloud.com. All rights reserved.
//

#import "IMSViewController.h"

#import <IMSForm/IMSForm.h>
#import "IMSCustomSingleSelectListView.h"
#import "IMSCustomMultipleSelectListView.h"
#import "IMSCustomInpuSearchListView.h"

#import "IMSFormConverter.h"

@interface IMSViewController () <UITableViewDelegate, UITableViewDataSource, IMSFormManagerUIDelegate, IMSFormManagerDataDelegate>

@property (strong, nonatomic) IMSFormManager *form; /**< <#property#> */
@property (strong, nonatomic) UITableView *tableView; /**< <#property#> */

@property (strong, nonatomic) UIView *customContactSingleListView; /**< <#property#> */
@property (strong, nonatomic) UIView *customAddressSingleListView; /**< <#property#> */

@end

@implementation IMSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.tableView];

    // MARK: regist cell class
//    @weakify(self);
//    [self.form.dataSource enumerateObjectsUsingBlock:^(IMSFormModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        @strongify(self);
//        [self.tableView registerClass:[[IMSFormTypeManager shared] getCellClassWithKey:obj.type] forCellReuseIdentifier:obj.type];
//    }];

    // MARK: 测试固定字段+自定义字段
    NSArray *fixedArray = [IMSFormDataManager formDataArrayWithJSON:[IMSFormDataManager readLocalJSONFileWithName:@"formData"]];

    NSArray *customArray = [IMSFormDataManager formDataArrayWithJSON:[IMSFormDataManager readLocalJSONFileWithName:@"customFormData"]];
    NSMutableArray <IMSFormModel *> *dataSource = [[NSMutableArray alloc] initWithArray:fixedArray];
    [dataSource addObjectsFromArray:customArray];

    // MARK: Sort dataSource
//    NSArray *order = @[@"email", @"search", @"progress", @"uniSelect", @"multipleSelect", @"switch", @"number", @"range", @"file", @"image", @"desc", @"line", @"name"];
//    NSArray *order = @[@"sectionHeader", @"email", @"search", @"progress", @"uniSelect", @"multipleSelect", @"switch", @"number", @"range", @"file", @"image", @"desc", @"line", @"name", @"sectionFooter"];
//    NSArray *order = @[@"email"];

    self.form.dataSource = [IMSFormDataManager sortFormDataArray:dataSource byOrder:nil];

    // MARK: 设置默认值 或 Edit模式的赋值
    for (IMSFormModel *model in self.form.dataSource) {
        if ([model.field isEqualToString:@"Currency"]) {
            model.value = @"12.34";
            model.valueList = [@[
                                   @{
                                       @"value": @"CNY"
                                   }
                               ] mutableCopy];
        } else if ([model.field isEqualToString:@"Phone"]) {
            model.value = @"12345678";
            model.valueList = [@[
                                   @{
                                       @"value": @"+86"
                                   }
                               ] mutableCopy];
        } else if ([model.field isEqualToString:@"File"]) {
            model.valueList = [@[
                                   @{
                                       @"url": @"http://www.baidu.com/jklaskjdlfkajldjfk.pdf",
                                       @"name": @"jklaskjdlfkajldjfk.pdf",
                                       @"id": @"fileIdentifier1"
                                   },
                                   @{
                                       @"url": @"http://www.baidu.com/jklaskjdlfkajldjfk.pdf",
                                       @"name": @"12978394h.pdf",
                                       @"id": @"fileIdentifier2"
                                   }
                               ] mutableCopy];
        } else if ([model.field isEqualToString:@"Image"]) {
            model.valueList = [@[
                                   @{
                                       @"url": @"http://www.tupian.com/images/Pages2_1.jpg",
                                       @"name": @"Pages2_1.jpg",
                                       @"id": @"image001"
                                   },
                                   @{
                                       @"url": @"http://www.tupian.com/images/Pages4_1.jpg",
                                       @"name": @"Pages2_2.jpg",
                                       @"id": @"image002"
                                   }
                               ] mutableCopy];
        } else if ([model.field isEqualToString:@"SingleSelect"]) {
            model.valueList = [@[
                                   @{
                                       @"value": @"value2"
                                   }
                               ] mutableCopy];
        } else if ([model.field isEqualToString:@"MultipleSelect"]) {
            model.valueList = [@[
                                   @{
                                       @"value": @"value11"
                                   },
                                   @{
                                       @"value": @"value21"
                                   }
                               ] mutableCopy];
        } else if ([model.field isEqualToString:@"Search"]) {
            model.valueList = [@[
                                   @{
                                       @"label": @"label2",
                                       @"value": @"value2"
                                   }
                               ] mutableCopy];
        } else if ([model.field isEqualToString:@"Name"]) {
            model.value = @"待修改的姓名";
        } else if ([model.field isEqualToString:@"Desc"]) {
            model.value = @"待修改的描述内容";
        } else if ([model.field isEqualToString:@"Number"]) {
            model.value = @"123";
        } else if ([model.field isEqualToString:@"Switch"]) {
            model.value = @"1";
        } else if ([model.field isEqualToString:@"Slider"]) {
            model.value = @"5";
        } else if ([model.field isEqualToString:@"Range"]) {
            model.value = @"1234;5678";
        } else if ([model.field isEqualToString:@"date"]) {
            model.value = @"1612890528";
        } else if ([model.field isEqualToString:@"datetime"]) {
            model.value = @"1612890600";
        } else if ([model.field isEqualToString:@"cascader"]) {
            model.valueList = [@[
                                   @{
                                       @"value": @"value1-3-1"
                                   },
                                   @{
                                       @"value": @"value1-3-2"
                                   }
                               ] mutableCopy];
        } else if ([model.field isEqualToString:@"InputTags"]) {
            model.valueList = [@[
                                   @{
                                       @"value": @"value1"
                                   },
                                   @{
                                       @"value": @"value2"
                                   },
                                   @{
                                       @"value": @"value3"
                                   },
                                   @{
                                       @"value": @"value4"
                                   }
                               ] mutableCopy];
        } else if ([model.field isEqualToString:@"radio"]) {
            model.valueList = [@[
                                   @{
                                       @"value": @"value3"
                                   }
                               ] mutableCopy];
        } else {}
    }

    [self.form.tableView reloadData];
}

#pragma mark - FormTableViewCell Events

- (void)didUpdatedFormTableViewCell:(IMSFormTableViewCell *)cell model:(IMSFormModel *)model indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", [cell.model.valueList yy_modelToJSONObject]); // 推荐方式
    NSLog(@"%@", [cell.model yy_modelToJSONObject]);
    NSLog(@"%@", [model yy_modelToJSONObject]);
    NSLog(@"%@", indexPath);
}

- (void)radioCellDidSelect:(UITableViewCell *)cell andCellModel:(IMSFormModel *)cellModel andIndexPath:(NSIndexPath *)indexPath andSelectModel:(IMSFormSelect *)selectModel {
    NSLog(@"%@", cellModel.valueList);
}

- (void)cascaderCellDidSelect:(UITableViewCell *)cell andCellModel:(IMSFormModel *)cellModel andIndexPath:(NSIndexPath *)indexPath andSelectModel:(id)object {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", cellModel.valueList);
}

- (void)inputTagCellDidSelect:(UITableViewCell *)cell andCellModel:(IMSFormModel *)cellModel andIndexPath:(NSIndexPath *)indexPath andSelectModel:(id)object {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", cellModel.valueList);
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.form.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMSFormModel *model = self.form.dataSource[indexPath.row];
//    IMSFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.type];
    IMSFormTableViewCell *cell = [IMSFormUIManager safe_dequeueReusableCellWithType:model.type tableView:tableView];
    [cell setModel:model form:self.form];
    // custom selector
    if ([cell respondsToSelector:@selector(setCustomDidSelectedBlock:)]) {
        [cell performSelector:@selector(setCustomDidSelectedBlock:) withObject:^(IMSFormTableViewCell *cell, IMSFormModel *model, id reservedObj) {
            SEL selector = NSSelectorFromString(model.customSelectorString);
            if ([self respondsToSelector:selector]) {
                IMP imp = [self methodForSelector:selector];
                void (*func)(id, SEL, id, id, id, id) = (void *)imp;
                func(self, selector, cell, model, indexPath, reservedObj);
            }
        }];
    }
    // default selector
    if ([cell respondsToSelector:@selector(setDidUpdateFormModelBlock:)]) {
        [cell performSelector:@selector(setDidUpdateFormModelBlock:) withObject:^(IMSFormTableViewCell *cell, IMSFormModel *model, id reservedObj) {
            SEL selector = NSSelectorFromString(model.defaultSelectorString);
            if ([self respondsToSelector:selector]) {
                IMP imp = [self methodForSelector:selector];
                void (*func)(id, SEL, id, id, id, id) = (void *)imp;
                func(self, selector, cell, model, indexPath, reservedObj);
            }
        }];
    }
    return cell;
}

#pragma mark - IMSFormManagerDelegate
- (IMSPopupSingleSelectListView *)customSingleSelectListViewWithFormModel:(IMSFormModel *)formModel
{
    // formModel.field
    if ([formModel.field isEqualToString:@"uniSelect"]) {
        IMSCustomSingleSelectListView *selectListView = [[IMSCustomSingleSelectListView alloc] init];
        selectListView.cellType = IMSPopupSingleSelectListViewCellType_Custom;
//        selectListView.dataArray = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:formModel.cpnConfig.selectDataSource];
        return selectListView;
    }
    return nil;
}

- (IMSPopupMultipleSelectListView *)customMultipleSelectListViewWithFormModel:(IMSFormModel *)formModel
{
    // formModel.filed
    if ([formModel.field isEqualToString:@"multipleSelect"]) {
        IMSCustomMultipleSelectListView *selectListView = [[IMSCustomMultipleSelectListView alloc] init];
        selectListView.cellType = IMSPopupMultipleSelectListViewCellType_Custom;
//        selectListView.dataArray = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:formModel.cpnConfig.selectDataSource];
        return selectListView;
    }
    return nil;
}

- (IMSPopupSingleSelectListView *)customInputSearchSelectListView
{
    return [[IMSCustomInpuSearchListView alloc] init];
}

#pragma mark - IMSFormManagerDataDelegate

- (void)testSearchInput:(NSString *)text completed:(nonnull void (^)(NSArray *_Nonnull))callback
{
    NSLog(@"%@", text);

    NSArray *resultArray = @[
        @{
            @"id": @"id1",
            @"label": @"value1 label",
            @"value": @"value1"
        },
        @{
            @"id": @"id2",
            @"label": @"value2 label",
            @"value": @"value2",

            @"name": @"姓名",
            @"phone": @"手机号",
            @"role": @"职位",
            @"info": @"个人简介"
        }
    ];
    if (callback) {
        callback(resultArray);
    }
}

- (void)IMSForm_UploadFile:(NSDictionary *)fileData completed:(void (^)(NSArray<NSDictionary *> *_Nonnull))callback
{
    NSLog(@"%@", fileData);

    if (callback) {
        NSArray *uploadResult = @[
            @{
                @"name": @"http://www.tupian.com/images/Pages3_1.jpg",
                @"id": @"fileIdentifier"
            }
        ];
        callback(uploadResult);
    }
}

- (void)IMSForm_UploadImages:(NSArray<UIImage *> *)photos completed:(nonnull void (^)(NSArray<NSDictionary *> *_Nonnull))callback
{
    NSLog(@"%@", photos);

    if (callback) {
        NSArray *uploadResult = @[
            @{
                @"url": @"http://www.tupian.com/images/Pages3_1.jpg",
                @"name": @"Page3_1.jpg",
                @"id": @"adafdsf"
            }
        ];
        callback(uploadResult);
    }
}

- (void)testUploadImages:(NSArray <UIImage *> *)photos completed:(void (^)(NSArray <NSString *> *))callback
{
    NSLog(@"%@", photos);

    if (callback) {
        NSArray *uploadResult = @[
            @{
                @"url": @"http://www.tupian.com/images/Pages3_1.jpg",
                @"name": @"Page3_1.jpg",
                @"id": @"adafdsf"
            }
        ];
        callback(uploadResult);
    }
}

- (void)testUploadFile:(NSDictionary *)fileData completed:(void (^)(NSArray <NSDictionary *> *))callback
{
    NSLog(@"%@", fileData);

    if (callback) {
        NSArray *uploadResult = @[
            @{
                @"name": @"http://www.tupian.com/images/Pages3_1.jpg",
                @"id": @"fileIdentifier"
            }
        ];
        callback(uploadResult);
    }
}

#pragma mark - Actions

- (IBAction)changeEditableAction:(id)sender {
    for (IMSFormModel *obj in self.form.dataSource) {
        obj.editable = !obj.isEditable;
    }
    [self.tableView reloadData];
}

- (IBAction)changeRequiredAction:(id)sender {
    for (IMSFormModel *obj in self.form.dataSource) {
        obj.required = !obj.isRequired;
    }
    [self.tableView reloadData];
}

- (IBAction)submitAction:(UIBarButtonItem *)sender
{
    [self.form submit:^(NSError *_Nonnull error) {
        NSLog(@"%@", self.form.dataSource);
        if (!error) {
            NSLog(@"校验通过");
            [IMSDropHUD showAlertWithType:IMSFormMessageType_Success message:@"校验通过"];
        } else {
            NSLog(@"校验未通过");
            [IMSDropHUD showAlertWithType:IMSFormMessageType_Error message:[NSString stringWithFormat:@"校验未通过: %@", error.localizedDescription]];
        }
    }];
}

#pragma mark - Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (IMSFormManager *)form
{
    if (!_form) {
        _form = [[IMSFormManager alloc] initWithTableView:self.tableView JSON:@"formDataa"];
        _form.uiDelegate = self;
        _form.dataDelegate = self;
    }
    return _form;
}

@end
