//
//  PickerViewMacro.h
//  unknownProjectName
//
//  Created by longli on 2019/7/2.
//  Copyright © 2019 ***** All rights reserved.
//


#ifndef PickerViewMacro_h
#define PickerViewMacro_h

// 屏幕大小、宽、高
#ifndef SCREEN_BOUNDS
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#endif
#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#endif
#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#endif

// RGB颜色(16进制)
#define PV_RGB_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

#define PV_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define PV_IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

// 等比例适配系数
#define kScaleFit (PV_IS_IPHONE ? ((SCREEN_WIDTH < SCREEN_HEIGHT) ? SCREEN_WIDTH / 375.0f : SCREEN_WIDTH / 667.0f) : 1.1f)

// 状态栏的高度(20 / 44(iPhoneX))
#define PV_STATUSBAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)
#define PV_IS_iPhoneX ((PV_STATUSBAR_HEIGHT == 44) ? YES : NO)
// 底部安全区域远离高度
#define PV_BOTTOM_MARGIN ((CGFloat)(PV_IS_iPhoneX ? 34 : 0))

#define kPickerHeight 216
#define kTopViewHeight 44.0
#define kBottomViewHeight 44.0
// 默认主题颜色
#define kDefaultThemeColor PV_RGB_HEX(0x464646, 1.0)
// topView视图的背景颜色
#define kPVToolBarColor PV_RGB_HEX(0xFDFDFD, 1.0f)

// 静态库中编写 Category 时的便利宏，用于解决 Category 方法从静态库中加载需要特别设置的问题
#ifndef PVSYNTH_DUMMY_CLASS

#define PVSYNTH_DUMMY_CLASS(_name_) \
@interface PVSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation PVSYNTH_DUMMY_CLASS_ ## _name_ @end

#endif

// 过期提醒
#define PVPickerViewDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 打印错误日志
#define PVErrorLog(...) NSLog(@"reason: %@", [NSString stringWithFormat:__VA_ARGS__])




#endif /* PickerViewMacro_h */
