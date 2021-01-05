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
        // TODO: Sort dataSource
    }
    return self;
}

#pragma mark - Public Methods

- (void)submit:(void (^)(BOOL))validateCompleted
{
    [self.tableView endEditing:YES];
    
    BOOL result = [IMSFormValidateManager validateFormDataSource:self.dataSource];
    if (validateCompleted) {
        validateCompleted(result);
    }
}

#pragma mark - Private Methods

#pragma mark - Getters


@end
