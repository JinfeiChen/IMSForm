//
//  IMSPopupSingleSelectLocationModel.h
//  IMSForm
//
//  Created by cjf on 26/2/2021.
//

#import <IMSForm/IMSFormSelect.h>

/**
 {
     City = "广州市";
     Country = "中国";
     CountryCode = CN;
     FormattedAddressLines =     (
         "中国广东省广州市海珠区新港中路352号丽影广场C区2楼"
     );
     Name = "卿卿我我餐厅(丽影广场店)";
     State = "广东省";
     Street = "新港中路352号丽影广场C区2楼";
     SubLocality = "海珠区";
     Thoroughfare = "新港中路352号丽影广场C区2楼";
 }
 */

NS_ASSUME_NONNULL_BEGIN

@interface IMSPopupSingleSelectLocationModel : IMSFormSelect

@property (copy, nonatomic) NSString *CountryCode; /**< 国家代号 */
@property (copy, nonatomic) NSString *Country; /**< 国家 */
@property (copy, nonatomic) NSString *State; /**< 省 */
@property (copy, nonatomic) NSString *City; /**< 市 */
@property (copy, nonatomic) NSString *SubLocality; /**< 区 */
@property (copy, nonatomic) NSString *Street; /**< 街道 */
@property (copy, nonatomic) NSString *Thoroughfare; /**< 地址 */
@property (copy, nonatomic) NSString *Name; /**< 名称 */
@property (copy, nonatomic) NSArray *FormattedAddressLines; /**< 格式化地址 */

@property (copy, nonatomic) NSString *Phone; /**< 电话 */
@property (copy, nonatomic) NSString *URL; /**< 网址 */

@end

NS_ASSUME_NONNULL_END
