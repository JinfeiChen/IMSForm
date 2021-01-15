//
//  IMSFormRadioModel.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import <IMSForm/IMSForm.h>
#import <IMSForm/IMSFormRadioCPNConfig.h>


NS_ASSUME_NONNULL_BEGIN

@interface IMSFormRadioModel : IMSFormModel
@property (nonatomic, strong) IMSFormRadioCPNConfig *cpnConfig;
@end

NS_ASSUME_NONNULL_END
