//
//  IMSFormRadioModel.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import "IMSFormRadioModel.h"

@implementation IMSFormRadioModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormRadioCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormRadioCPNConfig alloc] init];
    }
    return _cpnConfig;
}

- (void)setValueList:(NSMutableArray *)valueList {
    
    NSMutableArray *valueListM = [[NSMutableArray alloc]init];
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
    
    [super setValueList:valueListM.count ? valueListM : valueList];
}




@end
