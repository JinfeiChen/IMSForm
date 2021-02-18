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
   
    
    NSMutableArray *valueListM = [[NSMutableArray alloc]init];
    if (valueList && valueList.count) {
        NSArray *defaultSelectArray = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:valueList];
      NSArray *array = [self dealDefualValue:[NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:self.cpnConfig.dataSource] andHaveDataSource:defaultSelectArray andValueListM:valueListM];
        
        self.cpnConfig.dataSource = [array yy_modelToJSONObject];
    }
    
    [super setValueList:[valueListM yy_modelToJSONObject]];
}

- (NSArray *)dealDefualValue:(NSArray *)dataSource andHaveDataSource:(NSArray *)haveDataSource andValueListM:(NSMutableArray *)valueListM {
    
    for (int i = 0; i < dataSource.count; ++i) {
        IMSFormSelect *dataModel = dataSource[i];
        dataModel.selected = NO;
        for (IMSFormSelect *valueListModel in haveDataSource) {
            if ([dataModel.value isEqualToString:valueListModel.value]) {
                dataModel.selected = YES;
                [valueListM addObject:dataModel];
                break;
            }else {
                dataModel.selected = NO;
            }
        }
        if (i <= dataSource.count - 1 && dataModel.child.count) {
            [self dealDefualValue:dataModel.child andHaveDataSource:haveDataSource andValueListM:valueListM];
        }
    }
    
    return dataSource;
}

@end
