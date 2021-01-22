//
//  IMSFormConvertModel.m
//  test
//
//  Created by cjf on 20/1/2021.
//  Copyright © 2021 cjf. All rights reserved.
//

#import "IMSFormConvertModel.h"
#import "IMSFormConverter.h"

@implementation IMSFormConvertCPNConfig

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    
    
    return YES;
}

@end

@implementation IMSFormConvertModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    NSString *type = dic[@"name"];
    if (![type isKindOfClass:[NSString class]]) return NO;
    _type = [IMSFormConverter getCPNTypeWithWebCPNType:type];
    
    if ([type isEqualToString:@"Currency"]) {
        
    }
    
    NSString *label = dic[@"label"];
    if (![label isKindOfClass:[NSString class]]) return NO;
    _title = label;
    
    NSString *field = dic[@"dbType"];
    if (![field isKindOfClass:[NSString class]]) return NO;
    _field = field;
    
    NSNumber *enabled = dic[@"enabled"];
    if (![enabled isKindOfClass:[NSNumber class]]) return NO;
    _editable = [enabled boolValue];
    
    return YES;
}
    

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
//    if (!_title) return NO;
//    dic[@"timestamp"] = @(n.timeIntervalSince1970);
    return YES;
}


@end
