//
//  IMSFormUIManager.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <Foundation/Foundation.h>

#import <IMSForm/IMSFormTableViewCell.h>
#import <IMSForm/IMSFormTypeManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormUIManager : NSObject

// 安全获取可重用的UITableViewCell, 自动注册UITableViewCell
+ (IMSFormTableViewCell *)safe_dequeueReusableCellWithType:(IMSFormComponentType)type tableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
