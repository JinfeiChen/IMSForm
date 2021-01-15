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

## Structure

![image](https://git.imshktech.com/ios/imsform/images/structure.png)

## Usage

JSON Data

```
[
    {
        "type" : "IMSFormComponentType_TextField",
        
        "title" : "Email",
        "value" : "",
        "placeholder" : "Please enter your email address",
        "info" : "Max length limit 20",
        
        "visible" : "1",
        "editable" : "1",
        "required" : "1",
        "clearable" : "1",
        
        "field" : "email",
        "param" : "",
        
        "defaultSelectorString" : "didUpdatedMyFormModel:indexPath:",
        "customSelectorString" : "customDidSelectedMyFormModel:indexPath:",
        
        "cpnConfig" : {
            "textType" : "email",
            "lengthLimit" : "20",
            "precision" : "2"
        },
        "cpnStyle" : {
            "layout" : "vertical"
        },
        "cpnRule" : {
            "message" : {},
            "validators" : [
                {
                    "class" : "IMSMyValidateManager",
                    "selector" : "isNotEmpty"
                },
                {
                    "class" : "IMSFormValidateManager",
                    "selector" : "isEmail"
                }
            ],
            "trigger" : "change"
        }
    }
]
```

## Author

jinfei_chen@icloud.com, jinfei_chen@icloud.com

## License

IMSForm is available under the MIT license. See the LICENSE file for more info.
