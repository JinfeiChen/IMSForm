//
//  IMSFormMultiTextFieldModel.m
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import "IMSFormMultiTextFieldModel.h"

@implementation IMSFormMultiTextFieldModel

@synthesize cpnConfig = _cpnConfig;

- (IMSFormMultiTextFieldCPNConfig *)cpnConfig
{
    if (!_cpnConfig) {
        _cpnConfig = [[IMSFormMultiTextFieldCPNConfig alloc] init];
    }
    return _cpnConfig;
}

//- (NSMutableArray *)listArray
//{
//    if (!_listArray) {
//        _listArray = [NSMutableArray array];
//    }
//    return _listArray;
//}

@end
