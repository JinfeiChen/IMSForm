//
//  IMSFormUIManager.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormUIManager.h"

@implementation IMSFormUIManager

+ (IMSFormTableViewCell *)safe_dequeueReusableCellWithType:(IMSFormComponentType)type tableView:(UITableView *)tableView
{
    if (!tableView) {
        return [[IMSFormTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([IMSFormTableViewCell class])];
    }
    IMSFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:type];
    if (!cell) {
        [tableView registerClass:[[IMSFormTypeManager shared] getCellClassWithKey:type] forCellReuseIdentifier:type];
        cell = [tableView dequeueReusableCellWithIdentifier:type];
        return cell ? : [[IMSFormTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([IMSFormTableViewCell class])];
    }
    return cell;
}


@end
