//
//  IMSFormTypeManager.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <Foundation/Foundation.h>

#import <IMSForm/IMSFormType.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormTypeManager : NSObject

+ (instancetype)shared;

// 添加组件类型对应的类映射关系
- (void)registCellClass:(Class)cls forKey:(IMSFormComponentType)key;

// 根据组件类型获取对应的组件类
- (Class)getCellClassWithKey:(IMSFormComponentType)key;

// 根据组件类型获取对应的数据模型类
+ (Class)formModelClassWithCPNType:(IMSFormComponentType)cpnType;

@end

NS_ASSUME_NONNULL_END
