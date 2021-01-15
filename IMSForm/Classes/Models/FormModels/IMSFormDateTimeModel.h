//
//  IMSFormDateTimeModel.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import <IMSForm/IMSForm.h>
#import <IMSForm/IMSFormDateTimeCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormDateTimeModel : IMSFormModel
@property (nonatomic, strong) IMSFormDateTimeCPNConfig *cpnConfig;
@end

NS_ASSUME_NONNULL_END
