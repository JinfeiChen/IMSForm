//
//  IMSPopupSingleSelectContactModel.h
//  Raptor
//
//  Created by cjf on 18/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <IMSForm/IMSFormSelect.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSPopupSingleSelectContactModel : IMSFormSelect

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *info;

@end

NS_ASSUME_NONNULL_END
