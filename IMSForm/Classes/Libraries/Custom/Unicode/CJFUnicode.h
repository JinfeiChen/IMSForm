//
//  CJFUnicode.h
//  test
//  [说明]:
//  使用CJFUnicode可使Xcode控制台输出中文.
//  [用法]:
//  直接把CJFUnicode拖到工程里就能让Xcode支持中文的输出了.
//  [实现原理]:
//  原理就是利用runtime替换原有的description和descriptionWithLocale:还有descriptionWithLocale:indent:这几个方法.并转成让Xcode支持中文的编码.
//
//  Created by cjf on 26/2/2021.
//  Copyright © 2021 cjf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJFUnicode : NSObject

@end

NS_ASSUME_NONNULL_END
