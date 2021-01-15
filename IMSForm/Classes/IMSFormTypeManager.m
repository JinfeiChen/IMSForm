//
//  IMSFormTypeManager.m
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import "IMSFormTypeManager.h"

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
    // TODO: 添加全部默认提供的组件类型
    [self registCellClass:NSClassFromString(@"IMSFormTextFieldCell") forKey:IMSFormComponentType_TextField];
    [self registCellClass:NSClassFromString(@"IMSFormTextViewCell") forKey:IMSFormComponentType_TextView];
    [self registCellClass:NSClassFromString(@"IMSFormSliderCell") forKey:IMSFormComponentType_Slider];
    [self registCellClass:NSClassFromString(@"IMSFormSwitchCell") forKey:IMSFormComponentType_Switch];
    [self registCellClass:NSClassFromString(@"IMSFormNumberCell") forKey:IMSFormComponentType_Number];
    [self registCellClass:NSClassFromString(@"IMSFormRangeCell") forKey:IMSFormComponentType_Range];
    [self registCellClass:NSClassFromString(@"IMSFormFileCell") forKey:IMSFormComponentType_FileUpload];
    [self registCellClass:NSClassFromString(@"IMSFormImageCell") forKey:IMSFormComponentType_ImageUpload];
    [self registCellClass:NSClassFromString(@"IMSFormDateTimeCell") forKey:IMSFormComponentType_DateTimePicker];
    [self registCellClass:NSClassFromString(@"IMSFormSelectCell") forKey:IMSFormComponentType_Select];
    [self registCellClass:NSClassFromString(@"IMSFormInputSearchCell") forKey:IMSFormComponentType_InputSearch];
    [self registCellClass:NSClassFromString(@"IMSFormLineCell") forKey:IMSFormComponentType_Line];
    [self registCellClass:NSClassFromString(@"IMSFormRadioCell") forKey:IMSFormComponentType_Radio];
    [self registCellClass:NSClassFromString(@"IMSFormCascaderCell") forKey:IMSFormComponentType_Cascader];
    
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
    return [self.cellClassDict objectForKey:key];
}

+ (Class)formModelClassWithCPNType:(IMSFormComponentType)cpnType
{
    if ([cpnType isEqualToString:IMSFormComponentType_TextField]) {
        return NSClassFromString(@"IMSFormTextFieldModel");
    } else if ([cpnType isEqualToString:IMSFormComponentType_TextView]) {
        return NSClassFromString(@"IMSFormTextViewModel");
    } else if ([cpnType isEqualToString:IMSFormComponentType_Select]) {
        return NSClassFromString(@"IMSFormSelectModel");
    } else if ([cpnType isEqualToString:IMSFormComponentType_Slider]) {
        return NSClassFromString(@"IMSFormSliderModel");
    } else if ([cpnType isEqualToString:IMSFormComponentType_Switch]) {
        return NSClassFromString(@"IMSFormSwitchModel");
    } else if ([cpnType isEqualToString:IMSFormComponentType_Number]) {
        return NSClassFromString(@"IMSFormNumberModel");
    } else if ([cpnType isEqualToString:IMSFormComponentType_Range]) {
        return NSClassFromString(@"IMSFormRangeModel");
    } else if ([cpnType isEqualToString:IMSFormComponentType_FileUpload]) {
        return NSClassFromString(@"IMSFormFileModel");
    } else if ([cpnType isEqualToString:IMSFormComponentType_ImageUpload]) {
        return NSClassFromString(@"IMSFormImageModel");
    } else if ([cpnType isEqualToString:IMSFormComponentType_InputSearch]) {
        return NSClassFromString(@"IMSFormInputSearchModel");
    }else if ([cpnType isEqualToString:IMSFormComponentType_DateTimePicker]) {
        return NSClassFromString(@"IMSFormDateTimeModel");
    }else if ([cpnType isEqualToString:IMSFormComponentType_Radio]) {
        return NSClassFromString(@"IMSFormRadioModel");
    }else if ([cpnType isEqualToString:IMSFormComponentType_Cascader]) {
        return NSClassFromString(@"IMSFormCascaderModel");
    }else {
        return NSClassFromString(@"IMSFormModel");
    }
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

@end
