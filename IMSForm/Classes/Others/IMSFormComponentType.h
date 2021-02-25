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
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Cascader;//added

// Single selection component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Radio; // added

// Multiple selection component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Checkbox;

// Single Select List component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Select; // added

// Multiple Select List component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_MultiSelect; // added

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
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_DatePicker; // added
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_TimePicker; // added
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_DateTimePicker; // added
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_DateTimeRangePicker;

// Input Search
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_InputSearch; // added

// Currency
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Currency; // added

// Phone
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Phone; // added

// Phone
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_InputTag; // added

FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_MultiTextField;

FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_ImageControls;

#pragma mark - Readonly

// Seperator component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Line; // added

// Section head component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_SectionHeader; // added

// Section foot component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_SectionFooter; // added


