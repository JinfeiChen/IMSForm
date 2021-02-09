//
//  IMSFormCurrencyModel.m
//  IMSForm
//
//  Created by cjf on 22/1/2021.
//

#import "IMSFormCurrencyModel.h"

@implementation IMSFormCurrencyModel

- (instancetype)init
{
    if (self = [super init]) {
        self.value = @"0.0";
    }
    return self;
}

#pragma mark - Setters

- (void)setValueList:(NSMutableArray *)valueList
{
    [super setValueList:valueList];
    
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
            }
            [newDataSource addObject:mDict];
        }
        self.cpnConfig.dataSource = newDataSource;
    }
}

#pragma mark - Getters

@synthesize cpnConfig = _cpnConfig;

- (IMSFormCurrencyCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormCurrencyCPNConfig alloc] init];
    }
    return _cpnConfig;
}

@end
