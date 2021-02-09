//
//  IMSFormCascaderModel.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import "IMSFormCascaderModel.h"

@implementation IMSFormCascaderModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormCascaderCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormCascaderCPNConfig alloc] init];
    }
    return _cpnConfig;
}

- (void)setValueList:(NSMutableArray *)valueList {
    [super setValueList:valueList];
    
    if (valueList && valueList.count) {
        NSArray *defaultSelectArray = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:valueList];
      NSArray *array = [self dealDefualValue:[NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:self.cpnConfig.dataSource] andHaveDataSource:defaultSelectArray];
        
        self.cpnConfig.dataSource = [array yy_modelToJSONObject];
        
        NSLog(@"%@",array);
        
//        NSMutableArray *newDataSource = [NSMutableArray array];
//        for (NSDictionary *dict in self.cpnConfig.dataSource) {
//            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
//            IMSFormSelect *obj = [IMSFormSelect yy_modelWithDictionary:dict];
//            [mDict setValue:@(NO) forKey:@"selected"];
//            if ([defaultSelect.identifier isEqualToString:obj.identifier]) {
//                [mDict setValue:@(YES) forKey:@"selected"];
//            }
//            [newDataSource addObject:mDict];
//        }
//        self.cpnConfig.dataSource = newDataSource;
    }
}

- (NSArray *)dealDefualValue:(NSArray *)dataSource andHaveDataSource:(NSArray *)haveDataSource {
    
    for (int i = 0; i < dataSource.count; ++i) {
        IMSFormSelect *dataModel = dataSource[i];
        dataModel.selected = NO;
        for (IMSFormSelect *valueListModel in haveDataSource) {
            if ([dataModel.value isEqualToString:valueListModel.value]) {
                dataModel.selected = YES;
                break;
            }else {
                dataModel.selected = NO;
            }
        }
        if (i < dataSource.count - 1) {
            [self dealDefualValue:dataModel.child andHaveDataSource:haveDataSource];
        }
    }
    
    return dataSource;
}

@end
