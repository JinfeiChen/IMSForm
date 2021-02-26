//
//  IMSFormDateTimeRangeCPNConfig.m
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import "IMSFormDateTimeRangeCPNConfig.h"

@implementation IMSFormDateTimeRangeCPNConfig

- (instancetype)init
{
    if (self = [super init]) {
        _minDate = -36000;
        _maxDate = 36000;
        _datePickerType = IMSFormDateTimeType_Date;
    }
    return self;
}

@end
