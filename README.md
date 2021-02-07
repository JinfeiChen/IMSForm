# IMSForm

[![CI Status](https://img.shields.io/travis/jinfei_chen@icloud.com/IMSForm.svg?style=flat)](https://travis-ci.org/jinfei_chen@icloud.com/IMSForm)
[![Version](https://img.shields.io/cocoapods/v/IMSForm.svg?style=flat)](https://cocoapods.org/pods/IMSForm)
[![License](https://img.shields.io/cocoapods/l/IMSForm.svg?style=flat)](https://cocoapods.org/pods/IMSForm)
[![Platform](https://img.shields.io/cocoapods/p/IMSForm.svg?style=flat)](https://cocoapods.org/pods/IMSForm)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

IMSForm is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'IMSForm'
```

## IMSForm

![image](https://git.imshktech.com/ios/imsform/-/raw/Jenkins/images/IMSForm.png)

## Structure

![image](https://git.imshktech.com/ios/imsform/-/raw/Jenkins/images/structure.png)

## e.g. Custom Select UI

![image](https://git.imshktech.com/ios/imsform/-/raw/Jenkins/images/IMSFormSelectCell.png)

## Development

### 多语言支持

IMSForm 目前已支持多语言：English、Chinese Simplified

可根据需要增加其他语言配置文件

### 新增表单组件 Example

1.在 IMSFormComponentType 文件中创建类型枚举项 IMSFormComponentType_Example，创建 IMSFormTableViewCell 子类 IMSFormExampleCell;

2.[可选/按需]创建 IMSFormModel 子类 IMSFormExampleModel，作为 IMSFormExampleCell.model，并在.m文件添加 

```objective-c
@synthesize model = _model;
```

在 [IMSFormTypeManager formModelClassWithCPNType:] 中添加

```objective-c
if ([cpnType isEqualToString:IMSFormComponentType_Example]) {
    return NSClassFromString(@"IMSFormExampleModel");
}
```

3.[可选/按需]创建 IMSFormCPNConfig/IMSFormCPNStyle 子类，并在IMSFormExampleModel的.m文件中添加

```objective-c
@synthesize cpnConfig = _cpnConfig;
```

或

```objective-c
@synthesize cpnStyle = _cpnStyle;
```

4.添加类映射 - 在 [IMSFormTypeManager defaultRegist] 中添加 

```objective-c
[self registCellClass:NSClassFromString(@"IMSFormExampleCell") forKey:IMSFormComponentType_Example];
```

## Usage

### 全局配置表单主题色

在工程的info.plist文件中添加

```C
<key>IMSFormTintHexColor</key>
<string>0xFF0000</string>
```

如需要单独设置组件颜色，可在cpnStyle中配置 tintHexColor，单独设置的优先级高于全局。

### Form JSON Data

```
[
    {
        "type" : "IMSFormComponentType_InputTag",

        "title" : "Input Tags",

        "field" : "InputTags",

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_SectionHeader",

        "title" : "SectionHeader",

        "field" : "sectionHeader"
    },

    {
        "type" : "IMSFormComponentType_DateTimePicker",
        "title" : "Date first met",
        "placeholder" : "Please Select",
        "field" : "date",
        "cpnConfig" : {
            "datePickerMode" : 2,
            "minDate" : -36000,
            "maxDate" : 36000,
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_Radio",
        "title" : "radio",
        "field" : "radio",
        "cpnConfig" : {
            "normalImageName" : "ims-icon-radio-normal",
            "selectedImageName" : "ims-icon-radio-selected",
            "dataSource" : [
                {
                    "value" : "value1",
                    "selected" : 1,
                    "param" : ""
                },
                {
                    "value" : "value2",
                    "selected" : 0,
                    "param" : ""
                },
                {
                    "value" : "value3",
                    "selected" : 0,
                    "param" : ""
                }
            ]
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },
    {
        "type" : "IMSFormComponentType_Cascader",
        "title" : "cascader",
        "field" : "cascader",
        "cpnConfig" : {
            "maxCount" : 9,
            "didSelectedCount" : 0,
            "dataSource" : [
                {
                    "value" : "value1",
                    "selected" : 0,
                    "param" : "",
                    "child" : [
                        {
                            "value" : "value1-1",
                            "selected" : 0,
                            "param" : "",
                            "child" : [
                                {
                                    "value" : "value1-1-1",
                                    "selected" : 0,
                                    "param" : "",
                                    "child" : []

                                    ,
                                },
                                {
                                    "value" : "value1-1-2",
                                    "selected" : 0,
                                    "param" : "",
                                },
                            ]
                        },
                        {
                            "value" : "value3-1",
                            "selected" : 0,
                            "param" : ""
                        }
                    ],
                },
                {
                    "value" : "value2",
                    "selected" : 0,
                    "param" : "",
                }
            ]
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_Phone",

        "title" : "Phone",

        "field" : "Phone",

        "cpnConfig" : {
            "dataSource" : [
                {
                    "label" : "China",
                    "value" : "+86"
                },
                {
                    "label" : "America",
                    "value" : "+00",
                    "selected" : 1
                }
            ]
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_Currency",

        "title" : "Currency",

        "field" : "Currency",

        "cpnConfig" : {
            "dataSource" : [
                {
                    "label" : "China",
                    "value" : "CNY"
                },
                {
                    "label" : "America",
                    "value" : "USD",
                    "selected" : 1
                }
            ]
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_Currency",

        "title" : "Currency",

        "field" : "Currency",

        "cpnConfig" : {
            "dataSource" : [
                {
                    "label" : "China",
                    "value" : "CNY"
                },
                {
                    "label" : "America",
                    "value" : "USD"
                }
            ]
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_TextField",

        "title" : "Email",
        "customTitle" : "我是自定义的标题-Email",
        "value" : "dddddddddraptor@ims.com",
        "placeholder" : "Please enter your email address",
        "info" : "Max length limit 20",

        "visible" : "1",
        "editable" : 1,
        "required" : "1",
        "clearable" : "1",

        "field" : "email",
        "param" : "",

        "cpnConfig" : {
            "textType" : "url",
            "lengthLimit" : "20",
            "precision" : "2",
            "prefixUnit" : "金额:",
            "suffixUnit" : "asdf"
        },
        "cpnStyle" : {
            "layout" : "vertical",
            "infoHexColor" : "0xFF0000"
        },
        "cpnRule" : {
            "message" : {},
            "validators" : [
                {
                    "class" : "IMSMyValidateManager",
                    "selector" : "isNotEmpty"
                },
                "IMSFormModelEmailValidator"
            ],
            "trigger" : "blur"
        },

        "prefixModel" : {
            "valueList" : [
            ],
            "cpnConfig" : {
                "dataSource" : [
                    {
                        "value" : "CNY"
                    },
                    {
                        "value" : "USD"
                    },
                    {
                        "value" : "HKffffffffffffffffffffffffffff"
                    }
                ]
            }
        },

        "suffixModel" : {
            "valueList" : [
            ],
            "cpnConfig" : {
                "dataSource" : [
                    {
                        "value" : "CNY"
                    },
                    {
                        "value" : "USD"
                    },
                    {
                        "value" : "HKffffffffffffffffffffffffffff"
                    }
                ]
            }
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_InputSearch",

        "title" : "Input Search",
        "info" : "Info text",

        "required" : "1",
        "editable" : 1,

        "field" : "search",
        "param" : "",

        "cpnConfig" : {
            "selectItemType" : "default",
            "searchSelectorString" : "testSearchInput:completed:"
        },
        "cpnStyle" : {
            "layout" : "vertical"
        },
        "cpnRule" : {
            "validators" : [
                {
                    "class" : "IMSMyValidateManager",
                    "selector" : "isEmail",
                    "success" : {
                        "title" : "周董说：",
                        "message" : "唉哟，不错喔"
                    },
                    "failure" : {
                        "title" : "周董说：",
                        "message" : "Fuck you!"
                    }
                }
            ]
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_TextView",

        "title" : "Description",
        "info" : "Info text",

        "editable" : 1,

        "field" : "desc",

        "cpnConfig" : {
        },
        "cpnStyle" : {
            "layout" : "vertical"
        },
        "cpnRule" : {
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_Slider",

        "title" : "Progress",
        "info" : "Info text",

        "editable" : 1,

        "field" : "progress",

        "cpnConfig" : {
            "min" : "0",
            "max" : "10",
            "precision" : "3"
        },
        "cpnStyle" : {
            "layout" : "vertical"
        },
        "cpnRule" : {
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_Switch",

        "title" : "Switch",
        "info" : "Info text",

        "editable" : 1,

        "field" : "switch",

        "cpnConfig" : {
        },
        "cpnStyle" : {
            "layout" : "vertical",
            "bodyAlign" : "right"
        },
        "cpnRule" : {
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_Number",

        "title" : "Number",
        "info" : "Info text",

        "editable" : 1,

        "field" : "number",

        "cpnConfig" : {
            "min" : "0",
            "max" : "10000",
            "precision" : "0",
            "increment" : "1"
        },
        "cpnStyle" : {
            "layout" : "vertical"
        },
        "cpnRule" : {
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_Range",

        "title" : "Range",
        "value" : "123;1234",
        "info" : "Info text",

        "editable" : 1,

        "field" : "range",

        "cpnConfig" : {
            "min" : "0",
            "max" : "10000",
            "precision" : "3",
            "minPlaceholder" : "MIN",
            "maxPlaceholder" : "MAX"
        },
        "cpnStyle" : {
            "layout" : "vertical"
        },
        "cpnRule" : {
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_FileUpload",

        "title" : "File",
        
        "valueList" : [
            {
                "name" : "jklaskjdlfkajldjfk.pdf",
                "id" : "fileIdentifier1"
            },
            {
                "name" : "12978394h.pdf",
                "id" : "fileIdentifier2"
            }
        ],
        
        "cpnConfig" : {
            "maxFilesLimit" : 3,
            "fileUploadSelectorString" : "testUploadFile:completed:"
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_Line",

        "field" : "line"
    },

    {
        "type" : "IMSFormComponentType_ImageUpload",

        "title" : "Image",
        
        "valueList" : [
            "http://www.tupian.com/images/Pages2_1.jpg",
            "http://www.tupian.com/images/Pages4_1.jpg",
            "http://www.tupian.com/images/Pages2_1.jpg",
            "http://www.tupian.com/images/Pages4_1.jpg"
        ],
        
        "cpnConfig" : {
            "maxImagesLimit" : 8,
            "imageUploadSelectorString" : "testUploadImages:completed:"
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_SectionFooter",

        "title" : "SectionFooter",

        "field" : "sectionFooter"
    },

    {
        "type" : "IMSFormComponentType_Select",

        "title" : "Single Select",
        "valueList" : [],
        "placeholder" : "请单选",
        "info" : "这是个单选列表组件",

        "editable" : 1,
        "selected" : 0,

        "field" : "uniSelect",

        "cpnConfig" : {
            "selectItemType" : "contact",
            "dataSource" : [
                {
                    "value" : "value1",
                    "label" : "label1",
                    "selected" : 1,
                    "enable" : 0
                },
                {
                    "value" : "value2",
                    "label" : "label2",
                    "name" : "name2",
                    "phone" : "+86 188 8888 8888",
                    "role" : "role2",
                    "info" : "contact info text 2"
                }
            ]
        },
        "cpnStyle" : {
            "layout" : "vertical"
        },
        "cpnRule" : {
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    },

    {
        "type" : "IMSFormComponentType_MultiSelect",

        "title" : "Multiple Select",
        "valueList" : [],
        "placeholder" : "请多选",
        "info" : "这是个多选列表组件",

        "editable" : 1,
        "selected" : 0,

        "field" : "multipleSelect",

        "cpnConfig" : {
            "multipleLimit" : 20,
            "selectItemType" : "default",
            "dataSource" : [
                {
                    "value" : "section1",
                    "title" : "Section 1",
                    "child" : [
                        {
                            "value" : "value11",
                            "child" : []
                        },
                        {
                            "value" : "value12",
                            "child" : [],
                            "selected" : 1,
                            "enable" : 0
                        }
                    ]
                },
                {
                    "value" : "section2",
                    "title" : "Section 2",
                    "child" : [
                        {
                            "value" : "value21",
                            "child" : []
                        },
                        {
                            "value" : "value22",
                            "child" : []
                        },
                        {
                            "value" : "value23",
                            "child" : [],
                            "enable" : 0
                        },
                        {
                            "value" : "value24",
                            "child" : []
                        },
                        {
                            "value" : "value25",
                            "child" : []
                        },
                        {
                            "value" : "value26",
                            "child" : [],
                            "selected" : 1
                        }
                    ]
                }
            ]
        },
        "cpnStyle" : {
            "layout" : "vertical",

            "tintHexColor" : "0xFF0000"
        },
        "cpnRule" : {
        },

        "defaultSelectorString" : "didUpdatedFormTableViewCell:model:indexPath:"
    }
]

```

## Author

jinfei_chen@icloud.com, jinfei_chen@icloud.com

## License

IMSForm is available under the MIT license. See the LICENSE file for more info.
