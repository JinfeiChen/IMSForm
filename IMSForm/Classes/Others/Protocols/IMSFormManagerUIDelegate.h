//
//  IMSFormManagerUIDelegate.h
//  IMSForm
//
//  Created by cjf on 13/1/2021.
//

#import <Foundation/Foundation.h>
#import <IMSForm/IMSFormSelectCellDelegate.h>
#import <IMSForm/IMSFormInputSearchCellDelegate.h>
#import <IMSForm/IMSFormTextFieldCellDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMSFormManagerUIDelegate <NSObject, IMSFormSelectCellDelegate, IMSFormInputSearchCellDelegate, IMSFormTextFieldCellDelegate>

@end

NS_ASSUME_NONNULL_END
