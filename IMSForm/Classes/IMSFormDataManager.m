//
//  IMSFormDataManager.m
//  Pods
//
//  Created by cjf on 30/12/2020.
//

#import "IMSFormDataManager.h"

#import <YYModel/YYModel.h>

@implementation IMSFormDataManager

+ (NSArray *)readLocalJSONFileWithName:(NSString *)name
{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回数组形式
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&error];
    if (!data || error) {
        NSLog(@"JSON解码失败: %@", error.localizedDescription);
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
        if (obj.isVisible) {
            [mArr addObject:obj];
        }
    }];
    
    return mArr;
}

+ (NSArray *)jsonFromDataSource:(NSArray<IMSFormModel *> *)dataSource
{
    return [dataSource yy_modelToJSONObject];
}

+ (NSArray<IMSFormModel *> *)sortFormDataArray:(NSArray<IMSFormModel *> *)dataSource byOrder:(NSArray<NSString *> *)orderArray
{
    NSMutableArray *newDataSource = [NSMutableArray array];
    [orderArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"field contains [cd] %@", obj];
        NSArray *filterdArray = [dataSource filteredArrayUsingPredicate:predicate];
        [newDataSource addObjectsFromArray:filterdArray];
    }];
    return newDataSource;
}

@end
