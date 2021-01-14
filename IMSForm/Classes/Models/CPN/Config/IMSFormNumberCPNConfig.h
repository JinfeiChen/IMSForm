//
//  IMSFormNumberCPNConfig.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSForm.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormNumberCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic) CGFloat min; /**< 最小值, e.g. 0.0 */
@property (assign, nonatomic) CGFloat max; /**< 最大值, e.g. 10.0 */
@property (assign, nonatomic) CGFloat increment; /**< 增量, default 1.0 */
@property (assign, nonatomic) NSInteger precision; /**< 小数点精确度(小数点位数), default 2 */

@end

NS_ASSUME_NONNULL_END
