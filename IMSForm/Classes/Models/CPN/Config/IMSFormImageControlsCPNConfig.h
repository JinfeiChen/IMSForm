//
//  IMSFormImageControlsCPNConfig.h
//  IMSForm
//
//  Created by cjf on 25/2/2021.
//

#import <IMSForm/IMSFormCPNConfig.h>

/**
 Example:
 
 "cpnConfig" : {
     "maxImagesLimit" : 10,
     "rowImages" : 5,
     "dataSource" : [
         {
             "url": "http://www.tupian.com/images/Pages2_1.jpg",
             "name": "Pages2_1.jpg",
             "id": "image001"
         },
         {
             "url": "http://www.tupian.com/images/Pages4_1.jpg",
             "name": "Pages4_1.jpg",
             "id": "image002"
         }
     ]
 }
 */

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormImageControlsCPNConfig : IMSFormCPNConfig

@property (assign, nonatomic) NSInteger maxImagesLimit; /**< 最大图片数量, default 20 */
@property (assign, nonatomic) NSInteger rowImages; /**< 每行显示图片数量, 为了显示效果，maxImagesLimit最好为rowImages的倍数 */

@end

NS_ASSUME_NONNULL_END
