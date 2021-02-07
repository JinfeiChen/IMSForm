//
//  IMSFormManager.m
//  Pods
//
//  Created by cjf on 4/1/2021.
//

#import "IMSFormManager.h"

@implementation IMSFormManager

- (instancetype)initWithTableView:(UITableView *)tableView JSON:(NSString * _Nullable)jsonName
{
    if (self = [super init]) {
        _tableView = tableView;
        _dataSource = [IMSFormDataManager formDataArrayWithJSON:[IMSFormDataManager readLocalJSONFileWithName:jsonName]];
    }
    return self;
}

#pragma mark - Public Methods

- (void)submit:(void (^)(NSError * _Nonnull))validateCompleted
{
    [self.tableView endEditing:YES];
    
    NSError *error = [IMSFormValidateManager validateFormDataSource:self.dataSource];
    if (validateCompleted) {
        validateCompleted(error);
    }
}

#pragma mark - Private Methods

#pragma mark - Getters


@end
