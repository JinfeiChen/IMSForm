//
//  IMSFormType.h
//  Pods
//
//  Created by cjf on 31/12/2020.
//

#import <Foundation/Foundation.h>

// Custom string enumeration
typedef NSString *IMSFormType NS_STRING_ENUM;

#pragma mark - Edit

// Single line text input component
FOUNDATION_EXPORT IMSFormType const IMSFormType_TextField;

// Multi-line text input component
FOUNDATION_EXPORT IMSFormType const IMSFormType_TextView;

// Sliding component
FOUNDATION_EXPORT IMSFormType const IMSFormType_Slider;

// Switch component
FOUNDATION_EXPORT IMSFormType const IMSFormType_Switch;

// Counter component
FOUNDATION_EXPORT IMSFormType const IMSFormType_Number;

// Range component
FOUNDATION_EXPORT IMSFormType const IMSFormType_Range;

// Map component
FOUNDATION_EXPORT IMSFormType const IMSFormType_Map;

// Cascader component
FOUNDATION_EXPORT IMSFormType const IMSFormType_Cascader;

// Single selection component
FOUNDATION_EXPORT IMSFormType const IMSFormType_Radio;

// Multiple selection component
FOUNDATION_EXPORT IMSFormType const IMSFormType_Checkbox;

// Select component (multiple: YES or NO)
FOUNDATION_EXPORT IMSFormType const IMSFormType_Select;

// File upload component
FOUNDATION_EXPORT IMSFormType const IMSFormType_FileUpload;

// Image upload component
FOUNDATION_EXPORT IMSFormType const IMSFormType_ImageUpload;

// Scoring component
FOUNDATION_EXPORT IMSFormType const IMSFormType_Rate;

// Shuttle component
FOUNDATION_EXPORT IMSFormType const IMSFormType_Transfer;

// Color picker component
FOUNDATION_EXPORT IMSFormType const IMSFormType_ColorPicker;

// Date picker component
FOUNDATION_EXPORT IMSFormType const IMSFormType_DatePicker;

// Date and time picker component
FOUNDATION_EXPORT IMSFormType const IMSFormType_DateTimePicker;

// Time selector component
FOUNDATION_EXPORT IMSFormType const IMSFormType_TimePicker;

#pragma mark - Readonly

// Seperator component
FOUNDATION_EXPORT IMSFormType const IMSFormType_Line;

// Section head component
FOUNDATION_EXPORT IMSFormType const IMSFormType_SectionHeader;

// Section foot component
FOUNDATION_EXPORT IMSFormType const IMSFormType_SectionFooter;


