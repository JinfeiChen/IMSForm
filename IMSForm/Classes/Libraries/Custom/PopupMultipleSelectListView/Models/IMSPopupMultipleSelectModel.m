//
//  IMSPopupMultipleSelectModel.m
//  Raptor
//
//  Created by cjf on 22/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import "IMSPopupMultipleSelectModel.h"

@implementation IMSPopupMultipleSelectModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
        @"value": @[@"Value", @"value", @"Name"],
        @"label": @[@"Label", @"label"],
        @"childArray": @[@"Children", @"children"]
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        @"childArray": [IMSPopupMultipleSelectModel class],
        @"dataSourceArrayM": [IMSPopupMultipleSelectModel class]
    };
}

- (BOOL)noSelect {
    if ([_value isEqualToString:@"Internal Agent"]) {
        _noSelect = YES;
    }
    return _noSelect;
}

- (NSString *)Id {
    if (!_Id || _Id.length == 0) {
        return _value;
    }
    return _Id;
}

- (NSMutableArray *)dataSourceArrayM {
    if (_dataSourceArrayM == nil) {
        _dataSourceArrayM = [[NSMutableArray alloc] init];
    }
    return _dataSourceArrayM;
}

@end
