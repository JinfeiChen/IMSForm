//
//  IMSFormObject.h
//  Pods
//  自定义基类
//
//  Created by cjf on 30/12/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormObject : NSObject

@property (copy, nonatomic) NSString *identifier; /**< 唯一标识 */

@property (assign, nonatomic, getter=isEnabled) BOOL enabled; /**< 可用性 */

@property (copy, nonatomic) NSString *label; /**< 用于数据显示 */

@property (copy, nonatomic) NSString *value; /**< 用于数据存储 */

@end

NS_ASSUME_NONNULL_END
