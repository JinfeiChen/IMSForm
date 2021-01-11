//
//  IMSFormRadioCell.h
//  IMSForm
//
//  Created by IMS_Mac on 2021/1/11.
//

#import <IMSForm/IMSForm.h>

@interface IMSFormRadioModel : IMSFormSelect
@property (nonatomic, strong) NSString *normalImageName;
@property (nonatomic, strong) NSString *selectedImageName;
@end

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormRadioCell : IMSFormTableViewCell

@end

NS_ASSUME_NONNULL_END
