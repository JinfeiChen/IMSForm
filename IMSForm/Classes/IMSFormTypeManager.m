//
//  IMSFormTypeManager.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormTypeManager.h"
#import <objc/runtime.h>

@interface IMSFormTypeManager ()

@property (strong, nonatomic) NSMutableDictionary *cellClassDict; /**< <#property#> */

@end

@implementation IMSFormTypeManager

+ (instancetype)shared {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self defaultRegist];
    }
    return self;
}

- (void)defaultRegist
{
    for (NSString *key in [IMSFormTypeManager formCellClassMapping]) {
        [self registCellClass:NSClassFromString([[IMSFormTypeManager formCellClassMapping] valueForKey:key] ? : @"IMSFormTableViewCell") forKey:key];
    }
}

#pragma mark - Public Methods

- (void)registCellClass:(Class)cls forKey:(IMSFormComponentType)key
{
    if (cls && key) {
        [self.cellClassDict setObject:cls forKey:key];
    }
}

- (Class)getCellClassWithKey:(IMSFormComponentType)key
{
    if (!key || ![key isKindOfClass:[NSString class]]) {
        return [UITableViewCell class];
    }
    return [self.cellClassDict objectForKey:key] ? : NSClassFromString(@"IMSFormTableViewCell");
}

+ (Class)formModelClassWithCPNType:(IMSFormComponentType)cpnType
{
    return NSClassFromString([[self formModelClassMapping] valueForKey:cpnType] ? : @"IMSFormModel");
}

+ (NSInteger)selectItemTypeWithType:(IMSFormSelectItemType)type multiple:(BOOL)isMultiple
{
    if (!isMultiple) {
        if ([type isEqualToString:@"custom"]) {
            return 2; // IMSPopupSingleSelectListViewCellType_Custom
        } else if ([type isEqualToString:@"contact"]) {
            return 1; // IMSPopupSingleSelectListViewCellType_Contact
        } else {
            return 0; // IMSPopupSingleSelectListViewCellType_Default
        }
    } else {
        if ([type isEqualToString:@"custom"]) {
            return 1; // IMSPopupMultipleSelectListViewCellType_Custom
        } else {
            return 0; // IMSPopupMultipleSelectListViewCellType_Default
        }
    }
}

+ (Class)cpnConfigClassWithFormModelClass:(Class)modelClass
{
    if (!modelClass) {
        return NSClassFromString(@"IMSFormCPNConfig");
    }

    NSString *className = NSStringFromClass(modelClass);
    id model = [[NSClassFromString(className) alloc] init];

    // 取得类对象
    id classObject = objc_getClass([className UTF8String]);

    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    Ivar *ivars = class_copyIvarList(classObject, nil);

    for (int i = 0; i < count; i++) {
        const char *type = ivar_getTypeEncoding(ivars[i]);
        NSString *dataType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];

        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];

        if ([propertyName isEqualToString:@"cpnConfig"]) {
            return NSClassFromString([[dataType stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""]);
        }
    }

    return NSClassFromString(@"IMSFormCPNConfig");
}

#pragma mark - Private Methods

#pragma mark - Getters

- (NSMutableDictionary *)cellClassDict
{
    if (!_cellClassDict) {
        _cellClassDict = [NSMutableDictionary dictionary];
    }
    return _cellClassDict;
}

+ (NSDictionary *)formModelClassMapping
{
    // MARK: 请在这里添加全部默认提供的组件数据模型的类型映射
    return @{
        IMSFormComponentType_TextField : @"IMSFormTextFieldModel",
        IMSFormComponentType_TextView : @"IMSFormTextViewModel",
        IMSFormComponentType_Select : @"IMSFormSelectModel",
        IMSFormComponentType_MultiSelect : @"IMSFormMultiSelectModel",
        IMSFormComponentType_Slider : @"IMSFormSliderModel",
        IMSFormComponentType_Switch : @"IMSFormSwitchModel",
        IMSFormComponentType_Number : @"IMSFormNumberModel",
        IMSFormComponentType_Range : @"IMSFormRangeModel",
        IMSFormComponentType_FileUpload : @"IMSFormFileModel",
        IMSFormComponentType_ImageUpload : @"IMSFormImageModel",
        IMSFormComponentType_InputSearch : @"IMSFormInputSearchModel",
        
        IMSFormComponentType_DatePicker : @"IMSFormDateTimeModel",
        IMSFormComponentType_DateTimePicker : @"IMSFormDateTimeModel",
        IMSFormComponentType_TimePicker : @"IMSFormDateTimeModel",
        
        IMSFormComponentType_Radio : @"IMSFormRadioModel",
        IMSFormComponentType_Cascader : @"IMSFormCascaderModel",
        IMSFormComponentType_Currency : @"IMSFormCurrencyModel",
        IMSFormComponentType_Phone : @"IMSFormPhoneModel",
        IMSFormComponentType_InputTag : @"IMSFormInputTagModel",
        
        IMSFormComponentType_SectionHeader : @"IMSFormSectionHeaderModel",
        IMSFormComponentType_SectionFooter : @"IMSFormSectionFooterModel"
    };
}

+ (NSDictionary *)formCellClassMapping
{
    // MARK: 请在这里添加全部默认提供的组件类型映射
    return @{
        IMSFormComponentType_TextField : @"IMSFormTextFieldCell",
        IMSFormComponentType_TextView : @"IMSFormTextViewCell",
        IMSFormComponentType_Select : @"IMSFormSelectCell",
        IMSFormComponentType_MultiSelect : @"IMSFormMultiSelectCell",
        IMSFormComponentType_Slider : @"IMSFormSliderCell",
        IMSFormComponentType_Switch : @"IMSFormSwitchCell",
        IMSFormComponentType_Number : @"IMSFormNumberCell",
        IMSFormComponentType_Range : @"IMSFormRangeCell",
        IMSFormComponentType_FileUpload : @"IMSFormFileCell",
        IMSFormComponentType_ImageUpload : @"IMSFormImageCell",
        IMSFormComponentType_InputSearch : @"IMSFormInputSearchCell",
        
        IMSFormComponentType_DatePicker : @"IMSFormDateTimeCell",
        IMSFormComponentType_DateTimePicker : @"IMSFormDateTimeCell",
        IMSFormComponentType_TimePicker : @"IMSFormDateTimeCell",
        
        IMSFormComponentType_Radio : @"IMSFormRadioCell",
        IMSFormComponentType_Cascader : @"IMSFormCascaderCell",
        IMSFormComponentType_Currency : @"IMSFormCurrencyCell",
        IMSFormComponentType_Phone : @"IMSFormPhoneCell",
        IMSFormComponentType_InputTag : @"IMSFormInputTagCell",
        IMSFormComponentType_Line: @"IMSFormLineCell",
        IMSFormComponentType_SectionHeader : @"IMSFormSectionHeaderCell",
        IMSFormComponentType_SectionFooter : @"IMSFormSectionFooterCell"
    };
}

@end
