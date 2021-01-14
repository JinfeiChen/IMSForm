//
//  IMSFormComponentType.h
//  Pods
//  组件类型
//
//  Created by cjf on 31/12/2020.
//

#import <Foundation/Foundation.h>

// Custom string enumeration
typedef NSString *IMSFormComponentType NS_STRING_ENUM;

#pragma mark - Edit

// Single line text input component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_TextField; // added

// Multi-line text input component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_TextView; // added

// Sliding component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Slider; // added

// Switch component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Switch; // added

// Counter component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Number; // added

// Range component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Range; // added

// Map component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Map;

// Cascader component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Cascader;

// Single selection component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Radio;

// Multiple selection component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Checkbox;

// Select component (multiple: YES or NO)
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Select; // added

// File upload component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_FileUpload; // added

// Image upload component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_ImageUpload; // added

// Scoring component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Rate;

// Shuttle component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Transfer;

// Color picker component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_ColorPicker;

// Date and time picker component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_DateTimePicker;

// Input Search
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_InputSearch; // added

#pragma mark - Readonly

// Seperator component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Line; // added

// Section head component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_SectionHeader;

// Section foot component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_SectionFooter;


