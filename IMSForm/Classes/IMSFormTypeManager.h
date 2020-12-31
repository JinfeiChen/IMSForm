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

- (void)registCellClass:(Class)cls forKey:(IMSFormType)key;

- (Class)getCellClassWithKey:(IMSFormType)key;

@end

NS_ASSUME_NONNULL_END
