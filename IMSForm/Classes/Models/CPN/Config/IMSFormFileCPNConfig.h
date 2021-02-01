//
//  IMSFormFileCPNConfig.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormFileCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic) NSInteger maxFilesLimit; /**< 最大文件数量, default 20 */

@end

NS_ASSUME_NONNULL_END
