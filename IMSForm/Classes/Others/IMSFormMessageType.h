//
//  IMSFormMessageType.h
//  Pods
//  消息类型
//
//  Created by cjf on 4/1/2021.
//

#import <Foundation/Foundation.h>

typedef NSString *IMSFormMessageType NS_STRING_ENUM;

FOUNDATION_EXPORT IMSFormMessageType const IMSFormMessageType_Info; // default.

FOUNDATION_EXPORT IMSFormMessageType const IMSFormMessageType_Success;

FOUNDATION_EXPORT IMSFormMessageType const IMSFormMessageType_Warning;

FOUNDATION_EXPORT IMSFormMessageType const IMSFormMessageType_Error;
