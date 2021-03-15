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
   
    self.label = @"";
    NSMutableArray *valueListM = [[NSMutableArray alloc]init];
    NSMutableArray *titleArrayM = [[NSMutableArray alloc]init];
    BOOL subTip = YES;
    NSArray *defaultSelectArray = [NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:valueList];
    
    NSArray *array = [self dealDefualValue:[NSArray yy_modelArrayWithClass:[IMSFormSelect class] json:self.cpnConfig.dataSource] andFormSelectModel:nil andHaveDataSource:defaultSelectArray andValueListM:valueListM andTitleArrayM:titleArrayM andSubTip:subTip];
      self.cpnConfig.dataSource = [array yy_modelToJSONObject];
    
    if (valueListM.count) {
        [super setValueList:[valueListM yy_modelToJSONObject]];
    }else {
        [super setValueList:valueList];
    }
}

- (NSArray *)dealDefualValue:(NSArray *)dataSource andFormSelectModel:(IMSFormSelect *)selectModel andHaveDataSource:(NSArray *)haveDataSource andValueListM:(NSMutableArray *)valueListM andTitleArrayM:(NSMutableArray *)titleArrayM andSubTip:(BOOL)subTip {
    
//    NSLog(@"{ selectModel==>%@,\n titleArrayM ==> %@}",selectModel,titleArrayM);
    
    if (subTip && titleArrayM.count > 1) {
        [titleArrayM removeLastObject];
    }
    
    if (selectModel) {
        [titleArrayM addObject:selectModel.label ?: selectModel.value];
    }

    for (int i = 0; i < dataSource.count; ++i) {
        // 清空所有
        if (selectModel == nil) [titleArrayM removeAllObjects];
        
        IMSFormSelect *dataModel = dataSource[i];
        dataModel.selected = NO;
        for (IMSFormSelect *valueListModel in haveDataSource) {
            if ([dataModel.value isEqualToString:valueListModel.value]) {
                dataModel.selected = YES;
                subTip = NO;
                [titleArrayM addObject:dataModel.label ?: dataModel.value];
                if(self.cpnConfig.isMultiple == NO) {
                    if (titleArrayM.count > 1) {
                        self.label = [titleArrayM componentsJoinedByString:@" > "];
                    }else {
                        self.label = titleArrayM.firstObject;
                    }
                }
                [valueListM addObject:dataModel];
                break;
            }else {
                dataModel.selected = NO;
            }
        }
        if (i <= dataSource.count - 1 && dataModel.child.count) {
            [self dealDefualValue:dataModel.child andFormSelectModel:dataModel andHaveDataSource:haveDataSource andValueListM:valueListM andTitleArrayM:titleArrayM andSubTip:subTip];
        }
    }
    
    return dataSource;
}

@end
