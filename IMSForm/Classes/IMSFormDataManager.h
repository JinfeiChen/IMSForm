//
//  IMSFormDataManager.h
//  Pods
//
//  Created by cjf on 30/12/2020.
//

#import <IMSForm/IMSFormObject.h>

#import <IMSForm/IMSFormTypeManager.h>
#import <IMSForm/IMSFormUIManager.h>

#import <IMSForm/IMSFormModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormDataManager : IMSFormObject

// 读取本地JSON文件
+ (NSArray *)readLocalJSONFileWithName:(NSString *)name;
// 获取tableView用的数据源
+ (NSArray <IMSFormModel *> *)formDataArrayWithJSON:(NSArray *)jsonArrayData;
// 从tableView数据源获取json数据，用于提交服务器
+ (NSArray *)jsonFromDataSource:(NSArray <IMSFormModel *> *)dataSource;

@end

NS_ASSUME_NONNULL_END
