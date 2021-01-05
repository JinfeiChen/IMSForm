//
//  IMSFormComponentType.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <Foundation/Foundation.h>

// Custom string enumeration
typedef NSString *IMSFormComponentType NS_STRING_ENUM;

#pragma mark - Edit

// Single line text input component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_TextField;

// Multi-line text input component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_TextView;

// Sliding component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Slider;

// Switch component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Switch;

// Counter component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Number;

// Range component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Range;

// Map component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Map;

// Cascader component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Cascader;

// Single selection component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Radio;

// Multiple selection component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Checkbox;

// Select component (multiple: YES or NO)
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Select;

// File upload component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_FileUpload;

// Image upload component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_ImageUpload;

// Scoring component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Rate;

// Shuttle component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Transfer;

// Color picker component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_ColorPicker;

// Date picker component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_DatePicker;

// Date and time picker component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_DateTimePicker;

// Time selector component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_TimePicker;

#pragma mark - Readonly

// Seperator component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_Line;

// Section head component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_SectionHeader;

// Section foot component
FOUNDATION_EXPORT IMSFormComponentType const IMSFormComponentType_SectionFooter;


