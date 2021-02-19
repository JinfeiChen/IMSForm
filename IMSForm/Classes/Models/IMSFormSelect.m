//
//  IMSFormSelect.m
//  IMSForm
//
//  Created by cjf on 11/1/2021.
//

#import "IMSFormSelect.h"

@interface IMSFormSelect ()

@property (strong, nonatomic) NSDictionary *tempDict; /**< <#property#> */

@end

@implementation IMSFormSelect

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//        @"param" : @[@"id",@"Id",@"value",@"Value"]
//    };
//}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        @"child" : [IMSFormSelect class]
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    _tempDict = dic;
    if (!_param && [dic valueForKey:@"id"]) {
        _param = [dic valueForKey:@"id"];
    }
    if (!_param && [dic valueForKey:@"Id"]) {
        _param = [dic valueForKey:@"Id"];
    }
    if (!_param && [dic valueForKey:@"value"]) {
        _param = [dic valueForKey:@"value"];
    }
    if (!_param && [dic valueForKey:@"Value"]) {
        _param = [dic valueForKey:@"Value"];
    }
    self.identifier = _param;
    return YES;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if ([dic valueForKey:@"tempDict"]) {
        NSMutableDictionary *A = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSMutableDictionary *B = [NSMutableDictionary dictionaryWithDictionary:[dic valueForKey:@"tempDict"]];
        [B addEntriesFromDictionary:A];
        [dic addEntriesFromDictionary:B];
        [dic removeObjectForKey:@"tempDict"];
    }
    return YES;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.selected = NO;
        self.enable = YES;
    }
    return self;
}

@end
