//
//  IMSFormSectionFooterModel.m
//  IMSForm
//
//  Created by cjf on 1/2/2021.
//

#import "IMSFormSectionFooterModel.h"

@implementation IMSFormSectionFooterModel

@synthesize cpnStyle = _cpnStyle;

- (IMSFormSectionFooterCPNStyle *)cpnStyle
{
    if (!_cpnStyle) {
        _cpnStyle = [[IMSFormSectionFooterCPNStyle alloc] init];
    }
    return _cpnStyle;
}

@end
