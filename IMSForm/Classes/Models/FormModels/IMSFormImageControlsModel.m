//
//  IMSFormImageControlsModel.m
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import "IMSFormImageControlsModel.h"
#import <IMSForm/IMSFormSelect.h>

@implementation IMSFormImageControlsModel

#pragma mark - Setters

- (void)setValueList:(NSMutableArray *)valueList
{
    NSMutableArray *newDataSource = [NSMutableArray array];
    for (NSDictionary *dict in self.cpnConfig.dataSource) {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [mDict setValue:@(NO) forKey:@"selected"];
        [newDataSource addObject:mDict];
    }
    self.cpnConfig.dataSource = newDataSource;
    
    for (NSDictionary *modelDict in valueList) {
        IMSFormSelect *defaultSelect = [IMSFormSelect yy_modelWithDictionary:modelDict];
        NSMutableArray *newDataSource = [NSMutableArray array];
        for (NSDictionary *dict in self.cpnConfig.dataSource) {
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            IMSFormSelect *obj = [IMSFormSelect yy_modelWithDictionary:dict];
            if ([defaultSelect.identifier isEqualToString:obj.identifier]) {
                [mDict setValue:@(YES) forKey:@"selected"];
            }
            [newDataSource addObject:mDict];
        }
        self.cpnConfig.dataSource = newDataSource;
    }
    
    [super setValueList:valueList];
}

@synthesize cpnConfig = _cpnConfig;

- (IMSFormImageControlsCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormImageControlsCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
