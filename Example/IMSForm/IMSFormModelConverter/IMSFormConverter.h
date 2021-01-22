//
//  IMSFormConverter.h
//  test
//
//  Created by cjf on 20/1/2021.
//  Copyright © 2021 cjf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_STRING_ENUM;

@interface IMSFormConverter : NSObject

+ (NSString *)getCPNTypeWithWebCPNType:(NSString *)type;

+ (NSArray *)convertJsonArray:(NSArray *)jsonArray;

@end

NS_ASSUME_NONNULL_END
