//
//  IMSFormConverter.m
//  test
//
//  Created by cjf on 20/1/2021.
//  Copyright © 2021 cjf. All rights reserved.
//

#import "IMSFormConverter.h"

#import "IMSFormConvertModel.h"
#import <IMSForm/IMSForm.h>
#import <YYModel/YYModel.h>

@implementation IMSFormConverter

+ (NSArray *)convertPickListJSONArray:(NSArray *)jsonArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *obj in jsonArray) {
        
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        
        NSString *value = [obj valueForKey:@"Value__c"];
        if (value && [value isKindOfClass:[NSString class]]) {
            [mDict setValue:value forKey:@"value"];
        }
        
        if (mDict.count > 0) {
            [resultArray addObject:mDict];
        }
    }
    return resultArray;
}

+ (NSString *)getCPNTypeWithWebCPNType:(NSString *)type
{
    return [self mapCPNType:type];
}

+ (NSString *)getCPNConfigClassWithCPNType:(IMSFormComponentType)cpnType
{
    return @"";
}

+ (NSArray *)convertJsonArray:(NSArray *)jsonArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *obj in jsonArray) {
        
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        
        // type
        NSString *webType = [obj valueForKey:@"name"];
        if (webType) {
            NSString *CPNType = [self getCPNTypeWithWebCPNType:webType];
            [mDict setValue:CPNType forKey:@"type"];
            
            if ([webType isEqualToString:@"Date"]) {
                NSMutableDictionary *cpnConfigDict = [NSMutableDictionary dictionary];
                [cpnConfigDict setValue:@"IMSFormDateTimeType_Date" forKey:@"datePickerType"];
                [mDict setValue:cpnConfigDict forKey:@"cpnConfig"];
            }
            else if ([webType isEqualToString:@"DateTime"]) {
                NSMutableDictionary *cpnConfigDict = [NSMutableDictionary dictionary];
                [cpnConfigDict setValue:@"IMSFormDateTimeType_DateTime" forKey:@"datePickerType"];
                [mDict setValue:cpnConfigDict forKey:@"cpnConfig"];
            } else {}
        }
        
        // title
        NSString *webTitle = [obj valueForKey:@"label"];
        if (webTitle) {
            [mDict setValue:webTitle forKey:@"title"];
        }
        
        // field
        NSString *webField = [obj valueForKey:@"dbType"];
        if (webField) {
            [mDict setValue:webField forKey:@"field"];
        }
        
        // editable
        NSNumber *webEnable = [obj valueForKey:@"enabled"];
        if (webEnable) {
            [mDict setValue:webEnable forKey:@"editable"];
        }
        
        // cpnConfig
        NSDictionary *webCPNConfig = [obj objectForKey:@"cpnConfig"];
        if (webCPNConfig) {
            
            if ([webType isEqualToString:@"Currency"]) {
                
                NSMutableDictionary *suffixCPNConfigDict = [NSMutableDictionary dictionary];
                NSArray *values = [webCPNConfig valueForKey:@"values"];
                if (values) {
                    [suffixCPNConfigDict setValue:values forKey:@"dataSource"];
                }
                NSNumber *precision = [webCPNConfig valueForKey:@"precision"];
                if (precision) {
                    [suffixCPNConfigDict setValue:precision forKey:@"precision"];
                }
                NSNumber *min = [webCPNConfig valueForKey:@"min"];
                if (min) {
                    [suffixCPNConfigDict setValue:min forKey:@"min"];
                }
                NSNumber *max = [webCPNConfig valueForKey:@"max"];
                if (max) {
                    [suffixCPNConfigDict setValue:max forKey:@"max"];
                }
                [mDict setValue:suffixCPNConfigDict forKey:@"cpnConfig"];
                
            }
            else {
                [mDict setValue:webCPNConfig forKey:@"cpnConfig"];
            }
        }

        if (mDict.count > 0) {
            [resultArray addObject:mDict];
        }
        
    }
    return [resultArray copy];
}

+ (NSString *)typeWithIvarType:(NSString *)ivarType
{
    NSString *typeString = @"";
    if (![ivarType isKindOfClass:[NSString class]]) {
        return typeString;
    }
    if ([ivarType isEqualToString:@"i"]) {
        typeString = @"int";
    } else if ([ivarType isEqualToString:@"f"]) {
        typeString = @"float";
    } else if ([ivarType isEqualToString:@"d"]) {
        typeString = @"double|CGFloat";
    } else if ([ivarType isEqualToString:@"q"]) {
        typeString = @"NSInteger";
    } else if ([ivarType isEqualToString:@"B"]) {
        typeString = @"BOOL";
    } else {
        typeString = ivarType;
    }
    return typeString;
}

/**
 获取指定类（以及其父类）的所有属性

 @param cls 被获取属性的类
 @param until_class 当查找到此类时会停止查找，当设置为 nil 时，默认采用 [NSObject class]
 @return 属性名称 [NSString *]
 */
NSArray * getAllProperty(Class cls, Class until_class)
{
    Class stop_class = until_class ? : [NSObject class];

    if (class_getSuperclass(cls) == stop_class) return @[];

    NSMutableArray *all_p = [NSMutableArray array];

    [all_p addObjectsFromArray:getClassProperty(cls)];

    if (class_getSuperclass(cls) == stop_class) {
        return [all_p copy];
    } else {
        [all_p addObjectsFromArray:getAllProperty([cls superclass], stop_class)];
    }

    return [all_p copy];
}

/**
 获取指定类的属性

 @param cls 被获取属性的类
 @return 属性名称 [NSString *]
 */
NSArray * getClassProperty(Class cls)
{
    if (!cls) return @[];

    NSMutableArray *all_p = [NSMutableArray array];

    unsigned int a;

    objc_property_t *result = class_copyPropertyList(cls, &a);

    for (unsigned int i = 0; i < a; i++) {
        objc_property_t o_t =  result[i];
        [all_p addObject:[NSString stringWithFormat:@"%s", property_getName(o_t)]];
    }

    free(result);

    return [all_p copy];
}

NSMutableDictionary * getAllClassPropertyMapping(Class cls, Class until_class)
{
    NSMutableDictionary *all_map = [NSMutableDictionary dictionary];

    Class stop_class = until_class ? : [NSObject class];

    if (class_getSuperclass(cls) == stop_class) return [NSMutableDictionary dictionary];

//    NSMutableArray *all_p = [NSMutableArray array];

    NSMutableDictionary *tempMDict = getClassPropertyMapping(cls);
    [tempMDict addEntriesFromDictionary:all_map];
    all_map = tempMDict;
//    [all_p addObjectsFromArray:getClassProperty(cls)];

    if (class_getSuperclass(cls) == stop_class) {
        return all_map;
    } else {
        NSMutableDictionary *tempMDict = getAllClassPropertyMapping([cls superclass], stop_class);
        [tempMDict addEntriesFromDictionary:all_map];
        all_map = tempMDict;
//        [all_p addObjectsFromArray:getAllProperty([cls superclass], stop_class)];
    }

    return all_map;
}

NSMutableDictionary * getClassPropertyMapping(Class cls)
{
    NSMutableDictionary *P_C = [NSMutableDictionary dictionary];

    // 获取所有的成员变量
    unsigned int outCount = 0;
    Ivar *varList = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; ++i) {
        Ivar ivar = varList[i];
        //1.获取成员变量名字
        NSString *ivarname = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([ivarname hasPrefix:@"_"]) {
            //把 _ 去掉，读取后面的
            ivarname = [ivarname substringFromIndex:1];
        }
        //2.获取成员变量类型
        NSString *ivartype = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        //把包含 @\" 的去掉，如 "@\"nsstring\"";-="">
        NSString *ivarType = [ivartype stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        NSLog(@"ivarType = %@, ivarname = %@", typeWithIvarType(ivarType), ivarname);
        [P_C setValue:typeWithIvarType(ivarType) forKey:ivarname];
    }

    return P_C;
}

NSString * typeWithIvarType(NSString *ivarType)
{
    NSString *typeString = @"";
    if (![ivarType isKindOfClass:[NSString class]]) {
        return typeString;
    }
    if ([ivarType isEqualToString:@"i"]) {
        typeString = @"int";
    } else if ([ivarType isEqualToString:@"f"]) {
        typeString = @"float";
    } else if ([ivarType isEqualToString:@"d"]) {
        typeString = @"double|CGFloat";
    } else if ([ivarType isEqualToString:@"q"]) {
        typeString = @"NSInteger";
    } else if ([ivarType isEqualToString:@"B"]) {
        typeString = @"BOOL";
    } else if ([ivarType isEqualToString:@""]) {
        typeString = @"id";
    } else {
        typeString = ivarType;
    }
    return typeString;
}

// 不建议直接调用
+ (NSDictionary *)CPNTypeMapping
{
    return @{
        @"Text": IMSFormComponentType_TextField,
        @"Currency": IMSFormComponentType_Currency,
        @"Image": IMSFormComponentType_ImageUpload,
        @"Pick-List (Multi-Select)" : IMSFormComponentType_Select,
        @"Pick-List (Radio)" : IMSFormComponentType_Radio,
        @"Pick-List (Select)" : IMSFormComponentType_Select,
        @"DateTime" : IMSFormComponentType_DateTimePicker,
        @"Date" : IMSFormComponentType_DateTimePicker,
        @"Number" : IMSFormComponentType_Number,
        @"Switch" : IMSFormComponentType_Switch,
        @"Textarea" : IMSFormComponentType_TextView,
        @"File" : IMSFormComponentType_FileUpload
    };
}

// 不建议直接调用
+ (NSDictionary *)CPNPropertyMapping
{
    return @{
        @"label": @"title",
        @"name": @"type",
        @"dbType" : @"field"
    };
}

+ (NSDictionary *)WebPropertyChangeMapping
{
    return @{
        @"field" : @"dbType"
    };
}

+ (NSString *)mapCPNType:(NSString *)cpnType
{
    return [[self CPNTypeMapping] objectForKey:cpnType] ? : cpnType;
}

+ (NSString *)mapCPNPropertyKey:(NSString *)propertyName
{
    return [[self CPNPropertyMapping] objectForKey:propertyName] ? : propertyName;
}

+ (NSString *)mapWebPropertyKey:(NSString *)propertyName
{
    return [[self WebPropertyChangeMapping] objectForKey:propertyName] ? : propertyName;
}

+ (id)convertPropertyValueWithName:(NSString *)propertyName dict:(NSDictionary *)dict
{
    NSString *key = [self mapWebPropertyKey:propertyName];
    id obj = [dict objectForKey:key];
    if ([key isEqualToString:@"type"]) {
        return [self getCPNTypeWithWebCPNType:obj];
    } else {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            
            
        } else {
            return obj;
        }
    }
    
    return obj;
}

@end
