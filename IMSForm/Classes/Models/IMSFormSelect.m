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
    if ([dic valueForKey:@"value"]) {
        _param = [dic valueForKey:@"value"];
    }
    else if ([dic valueForKey:@"Value"]) {
        _param = [dic valueForKey:@"Value"];
    }
    else if ([dic valueForKey:@"id"]) {
        _param = [dic valueForKey:@"id"];
    }
    else if ([dic valueForKey:@"Id"]) {
        _param = [dic valueForKey:@"Id"];
    }
    else {
        
    }
    return YES;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if ([dic valueForKey:@"tempDict"]) {
        [dic addEntriesFromDictionary:[dic valueForKey:@"tempDict"]];
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
