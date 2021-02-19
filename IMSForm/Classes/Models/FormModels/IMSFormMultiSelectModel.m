//
//  IMSFormMultiSelectModel.m
//  IMSForm
//
//  Created by cjf on 1/2/2021.
//

#import "IMSFormMultiSelectModel.h"
#import <IMSForm/IMSFormSelect.h>

@implementation IMSFormMultiSelectModel

#pragma mark - Setters

- (void)setValueList:(NSMutableArray *)valueList
{
    NSMutableArray *mValueList = [NSMutableArray array];
    if (valueList && valueList.count > 0) {
        self.cpnConfig.dataSource = [self deselectedDataSource:self.cpnConfig.dataSource];
        for (NSDictionary *modelDict in valueList) {
            IMSFormSelect *selectedModel = [IMSFormSelect yy_modelWithDictionary:modelDict];
            self.cpnConfig.dataSource = [self updateDataSource:self.cpnConfig.dataSource identifier:selectedModel.identifier];
        }
        mValueList = [[self filterSelectedDataSource:self.cpnConfig.dataSource] mutableCopy];
    }
    
    [super setValueList:(mValueList.count>0)?mValueList:valueList];
}

- (NSArray *)deselectedDataSource:(NSArray *)dataSource
{
    NSMutableArray *newDataSource = [NSMutableArray array];
    for (NSDictionary *obj in dataSource) {
        NSMutableDictionary *mObj = [NSMutableDictionary dictionaryWithDictionary:obj];
        [mObj setValue:@(NO) forKey:@"selected"];
        NSArray *child = [mObj valueForKey:@"child"];
        if (child && child.count > 0) {
            NSArray *newChild = [self deselectedDataSource:child];
            [mObj setValue:newChild forKey:@"child"];
        }
        [newDataSource addObject:mObj];
    }
    return newDataSource;
}

- (NSArray *)updateDataSource:(NSArray *)dataSource identifier:(NSString *)identifier
{
    NSMutableArray *newDataSource = [NSMutableArray array];
    for (NSDictionary *obj in dataSource) {
        NSMutableDictionary *mObj = [NSMutableDictionary dictionaryWithDictionary:obj];
        IMSFormSelect *model = [IMSFormSelect yy_modelWithDictionary:obj];
        if (model.child && model.child.count > 0) {
            NSArray *child = [self updateDataSource:[mObj valueForKey:@"child"] identifier:identifier];
            [mObj setValue:child forKey:@"child"];
        } else {
            if ([identifier isEqualToString:model.identifier]) {
                [mObj setValue:@(YES) forKey:@"selected"];
            }
        }
        [newDataSource addObject:mObj];
    }
    return newDataSource;
}

- (NSArray *)filterSelectedDataSource:(NSArray *)dataSource
{
    NSMutableArray *newDataSource = [NSMutableArray array];
    for (NSDictionary *obj in dataSource) {
        IMSFormSelect *model = [IMSFormSelect yy_modelWithDictionary:obj];
        if (model.child && model.child.count > 0) {
            NSArray *child = [self filterSelectedDataSource:[obj valueForKey:@"child"]];
            [newDataSource addObjectsFromArray:child];
        } else {
            if (model.selected) {
                [newDataSource addObject:obj];
            }
        }
    }
    return newDataSource;
}

#pragma mark - Getters

@synthesize cpnConfig = _cpnConfig;

- (IMSFormMultiSelectCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormMultiSelectCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
