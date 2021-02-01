//
//  IMSFormSectionHeaderModel.m
//  IMSForm
//
//  Created by cjf on 1/2/2021.
//

#import "IMSFormSectionHeaderModel.h"

@implementation IMSFormSectionHeaderModel

@synthesize cpnStyle = _cpnStyle;

- (IMSFormSectionHeaderCPNStyle *)cpnStyle
{
    if (!_cpnStyle) {
        _cpnStyle = [[IMSFormSectionHeaderCPNStyle alloc] init];
    }
    return _cpnStyle;
}

@end
