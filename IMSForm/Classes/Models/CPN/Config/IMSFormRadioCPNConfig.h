//
//  IMSFormRadioCPNConfig.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/14.
//

#import <IMSForm/IMSFormCPNConfig.h>
#import <IMSForm/IMSFormSelect.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormRadioCPNConfig : IMSFormCPNConfig

//@property (nonatomic, strong) NSString *normalImageName;
//@property (nonatomic, strong) NSString *selectedImageName;
@property (strong, nonatomic) NSArray *selectDataSource; /**< 数据列表 */
@end

NS_ASSUME_NONNULL_END
