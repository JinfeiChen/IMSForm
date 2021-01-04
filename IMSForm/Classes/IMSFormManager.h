//
//  IMSFormManager.h
//  Pods
//
//  Created by cjf on 4/1/2021.
//

#import <IMSForm/IMSForm.h>

#import <IMSForm/IMSFormMacros.h>
#import <IMSForm/IMSFormDataManager.h>
#import <IMSForm/IMSFormLocalizedManager.h>
#import <IMSForm/IMSFormTypeManager.h>
#import <IMSForm/IMSFormValidateManager.h>
#import <IMSForm/IMSFormUIManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormManager : IMSFormObject

@property (strong, nonatomic) UITableView *tableView; /**< <#property#> */
@property (strong, nonatomic) NSArray <IMSFormModel *> *dataSource; /**< <#property#> */

@property (strong, nonatomic) IMSFormValidateManager *validate; /**< <#property#> */

- (instancetype)initWithTableView:(UITableView *)tableView JSON:(NSString *)jsonName;

- (void)submit:(void(^)(BOOL isPass))validateBlock;

@end

NS_ASSUME_NONNULL_END
