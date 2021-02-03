//
//  IMSFormDataManager.m
//  Pods
//
//  Created by cjf on 30/12/2020.
//

#import "IMSFormDataManager.h"

#import <YYModel/YYModel.h>
#import <IMSForm/NSString+Extension.h>

@implementation IMSFormDataManager

+ (NSArray *)readLocalJSONFileWithName:(NSString *)name
{
    if (!name || ![name isKindOfClass:[NSString class]]) {
        return nil;
    }
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    if (!data) {
        return nil;
    }
    // 对数据进行JSON格式化并返回数组形式
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&error];
    if (!data || error) {
        NSLog(@"%@: %@", @"JSON decoding failed".ims_localizable, error.localizedDescription);
        return nil;
    } else {
        return jsonObj;
    }
}

+ (NSArray <IMSFormModel *> *)formDataArrayWithJSON:(NSArray *)jsonArrayData
{
    if (!jsonArrayData) { return nil; }
    
    
    NSArray <IMSFormModel *> *array = [NSArray yy_modelArrayWithClass:[IMSFormModel class] json:jsonArrayData];
    NSMutableArray *mArr = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(IMSFormModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class newModelClass = [IMSFormTypeManager formModelClassWithCPNType:obj.type];
        NSArray *newModelArr = [NSArray yy_modelArrayWithClass:newModelClass json:@[[jsonArrayData objectAtIndex:idx]]];
        [mArr addObjectsFromArray:newModelArr];
    }];
    
    return mArr;
}

+ (NSArray *)jsonFromDataSource:(NSArray<IMSFormModel *> *)dataSource
{
    return [dataSource yy_modelToJSONObject];
}

+ (NSArray<IMSFormModel *> *)sortFormDataArray:(NSArray<IMSFormModel *> *)dataSource byOrder:(NSArray<NSString *> *)orderArray
{
    NSMutableArray *unSortedArray = [NSMutableArray array];
    NSMutableArray *sortedArray = [NSMutableArray array];
    [orderArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"field contains [cd] %@", obj];
        NSArray *filterdArray = [dataSource filteredArrayUsingPredicate:predicate];
        [sortedArray addObjectsFromArray:filterdArray];
    }];
    [dataSource enumerateObjectsUsingBlock:^(IMSFormModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![sortedArray containsObject:obj]) {
            [unSortedArray addObject:obj];
        }
    }];
    [sortedArray addObjectsFromArray:unSortedArray];
    return sortedArray;
}

@end
