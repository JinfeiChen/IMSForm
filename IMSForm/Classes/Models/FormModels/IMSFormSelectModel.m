//
//  IMSFormSelectModel.m
//  IMSForm
//
//  Created by cjf on 14/1/2021.
//

#import "IMSFormSelectModel.h"
#import <IMSForm/IMSFormSelect.h>

@implementation IMSFormSelectModel

#pragma mark - Setters

- (void)setValueList:(NSMutableArray *)valueList
{
    
    NSMutableArray *valueListM = [[NSMutableArray alloc]init];
    if (valueList && valueList.count == 1) {
        NSDictionary *modelDict = valueList.firstObject;
        IMSFormSelect *defaultSelect = [IMSFormSelect yy_modelWithDictionary:modelDict];
        NSMutableArray *newDataSource = [NSMutableArray array];
        for (NSDictionary *dict in self.cpnConfig.dataSource) {
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            IMSFormSelect *obj = [IMSFormSelect yy_modelWithDictionary:dict];
            [mDict setValue:@(NO) forKey:@"selected"];
            if ([defaultSelect.identifier isEqualToString:obj.identifier]) {
                [mDict setValue:@(YES) forKey:@"selected"];
                [valueListM addObject:mDict];
            }
            [newDataSource addObject:mDict];
        }
        self.cpnConfig.dataSource = newDataSource;
    }
    
    [super setValueList:valueListM.count ? valueListM : valueList]
}

#pragma mark - Getters

@synthesize cpnConfig = _cpnConfig;

- (IMSFormSelectCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormSelectCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
