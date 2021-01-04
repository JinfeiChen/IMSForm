//
//  IMSFormManager.m
//  Pods
//
//  Created by cjf on 4/1/2021.
//

#import "IMSFormManager.h"

@implementation IMSFormManager

- (instancetype)initWithTableView:(UITableView *)tableView JSON:(NSString *)jsonName
{
    if (self = [super init]) {
        _tableView = tableView;
        _dataSource = [IMSFormDataManager formDataArrayWithJSON:[IMSFormDataManager readLocalJSONFileWithName:jsonName]];
    }
    return self;
}

#pragma mark - Public Methods

- (void)submit:(void (^)(BOOL))validateBlock
{
    BOOL result = [IMSFormValidateManager validateFormDataSource:self.dataSource validator:self.validate];
    if (validateBlock) {
        validateBlock(result);
    }
}

#pragma mark - Private Methods

#pragma mark - Getters

- (IMSFormValidateManager *)validate
{
    if (!_validate) {
        _validate = [[IMSFormValidateManager alloc] init];
    }
    return _validate;
}


@end
