//
//  IMSFormDateTimeCPNConfig.m
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import "IMSFormDateTimeCPNConfig.h"

@implementation IMSFormDateTimeCPNConfig

- (instancetype)init {
    if (self = [super init]) {
        _minDate = -36000;
        _maxDate = 36000;
        _datePickerType = IMSFormDateTimeType_Time;
    }
    return self;
}

@end
