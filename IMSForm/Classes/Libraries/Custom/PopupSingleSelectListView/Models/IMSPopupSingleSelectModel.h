//
//  IMSPopupSingleSelectModel.h
//  Raptor
//
//  Created by cjf on 18/12/2020.
//  Copyright © 2020 IMS. All rights reserved.
//

#import <IMSForm/IMSFormObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSPopupSingleSelectModel : IMSFormObject

// common
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
// model 1
@property (nonatomic, assign) BOOL noSelect; // yes:不允许选择
@property (nonatomic, assign) NSInteger buttonState; // 选择类型 0：未选中状态， 1：选中状态  2：高亮状态
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, strong) NSArray <IMSPopupSingleSelectModel *> *childArray;
// model 2
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Phone;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *Contact_Roles__c;
@property (nonatomic, copy) NSString *RecordTypeName;
@property (nonatomic, strong) NSString *Status;
@property (nonatomic, strong) NSString *Type;
@property (nonatomic, strong) NSString *StartDate;
@property (nonatomic, strong) NSString *EndDate;

@end

NS_ASSUME_NONNULL_END
