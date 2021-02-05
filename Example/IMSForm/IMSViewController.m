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
    
    
//    NSArray *jsonArray = [IMSFormDataManager readLocalJSONFileWithName:@"customField"];
//    NSArray *targetArray = [IMSFormConverter convertJsonArray:jsonArray];
//    NSLog(@"%@", targetArray);
//
//    self.form.dataSource = [IMSFormDataManager formDataArrayWithJSON:targetArray];
    
    [self.form.tableView reloadData];
}

#pragma mark - FormTableViewCell Events

- (void)didUpdatedMyFormModel:(IMSFormModel *)model indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", model);
    NSLog(@"%@", indexPath);
}

- (void)customDidSelectedMyFormModel:(IMSFormModel *)model indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", model);
    NSLog(@"%@", indexPath);
}

- (void)radioCellDidSelect:(UITableViewCell *)cell andCellModel:(IMSFormModel *)cellModel andIndexPath:(NSIndexPath *)indexPath andSelectModel: (IMSFormSelect *)selectModel {
    NSLog(@"%@", cellModel.valueList);
}

- (void)cascaderCellDidSelect:(UITableViewCell *)cell andCellModel:(IMSFormModel *)cellModel andIndexPath:(NSIndexPath *)indexPath andSelectModel: (id)object {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", cellModel.valueList);

}

- (void)inputTagCellDidSelect:(UITableViewCell *)cell andCellModel:(IMSFormModel *)cellModel andIndexPath:(NSIndexPath *)indexPath andSelectModel: (id)object {
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

- (void)customInputSearchWithFormModel:(IMSFormModel *)formModel completation:(nonnull void (^)(IMSPopupSingleSelectListView * _Nullable, NSArray * _Nonnull))callback
{
    // 这里的json数据可通过服务器获取，再转换成IMSFormSelect类型的对象数组
    NSArray *dataArray = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:@[
        @{
            @"value" : @"value1"
        },
        @{
            @"value" : @"value2"
        }
    ]];
    if (callback) {
        IMSCustomInpuSearchListView *selectListView = [[IMSCustomInpuSearchListView alloc] init];
        callback(selectListView, dataArray);
    }
}

#pragma mark - IMSFormManagerDataDelegate

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
    [self.form submit:^(NSError * _Nonnull error) {
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
