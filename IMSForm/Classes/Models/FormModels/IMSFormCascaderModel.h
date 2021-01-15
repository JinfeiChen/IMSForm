//
//  IMSFormCascaderModel.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import <IMSForm/IMSForm.h>
#import <IMSForm/IMSFormCascaderCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormCascaderModel : IMSFormModel
@property (nonatomic, strong) IMSFormCascaderCPNConfig *cpnConfig;
@end

NS_ASSUME_NONNULL_END
