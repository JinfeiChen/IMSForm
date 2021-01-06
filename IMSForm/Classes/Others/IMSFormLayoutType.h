//
//  IMSFormLayoutType.h
//  Pods
//  组件布局方式
//
//  Created by cjf on 5/1/2021.
//

#import <Foundation/Foundation.h>

typedef NSString *IMSFormLayoutType NS_STRING_ENUM;

FOUNDATION_EXPORT IMSFormLayoutType const IMSFormLayoutType_Vertical; // default.

FOUNDATION_EXPORT IMSFormLayoutType const IMSFormLayoutType_Horizontal;

typedef NSString *IMSFormBodyAlign NS_STRING_ENUM;

FOUNDATION_EXPORT IMSFormBodyAlign const IMSFormBodyAlign_Right; // default.

FOUNDATION_EXPORT IMSFormBodyAlign const IMSFormBodyAlign_Left;
