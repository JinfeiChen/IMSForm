//
//  IMSFormConverter.h
//  test
//
//  Created by cjf on 20/1/2021.
//  Copyright © 2021 cjf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSFormConverter : NSObject

+ (NSString *)getCPNTypeWithWebCPNType:(NSString *)type;

+ (NSArray *)convertJsonArray:(NSArray *)jsonArray;

+ (NSArray *)convertPickListJSONArray:(NSArray *)jsonArray;

@end

NS_ASSUME_NONNULL_END
