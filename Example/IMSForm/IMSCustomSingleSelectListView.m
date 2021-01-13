//
//  IMSCustomSingleSelectListView.m
//  IMSForm_Example
//
//  Created by cjf on 12/1/2021.
//  Copyright © 2021 jinfei_chen@icloud.com. All rights reserved.
//

#import "IMSCustomSingleSelectListView.h"

@implementation IMSCustomSingleSelectListView

- (UITableViewCell *)customTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: identifier];
    }
    IMSFormSelect *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.value;
    return cell;
}

@end
