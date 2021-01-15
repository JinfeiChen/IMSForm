//
//  IMSFormMacros.h
//  Pods
//
//  Created by cjf on 30/12/2020.
//

#ifndef IMSFormMacros_h
#define IMSFormMacros_h

#define IMSAppWindow [[UIApplication sharedApplication].delegate window]

#define IMS_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define IMS_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IMS_STATUSBAR_HEIGHT (IMS_SCREEN_IS_PORTRAIT?((IMS_IS_IPHONEX()==YES)?44.f:20.f):0)
#define IMS_NAVIGATION_CONTENT_HEIGHT 44.f
#define IMS_NAVIGATIONBAR_HEIGHT (IMS_STATUSBAR_HEIGHT + IMS_NAVIGATION_CONTENT_HEIGHT)
#define IMS_TABBAR_HEIGHT (IMS_IS_IPHONEX()?83.f:49.f)
#define IMS_HOMEKEY_HEIGHT (IMS_IS_IPHONEX()?34.f:0)

//iOS11的新特性代码,
//注意: 这个必须等应用准备好了才能调用，否则会在[... windows][0]调用时崩溃
#define IMS_IS_IPHONEX() ^(){\
if (@available(iOS 11.0, *)) {\
UIWindow *keyWindow = nil;\
for (UIWindow *window in [UIApplication sharedApplication].windows) {\
    if (window.isKeyWindow) {\
        keyWindow = window;\
    }\
}\
return (keyWindow.safeAreaInsets.bottom > 0.0)?1:0;\
} else {\
return 0;\
}\
}()

// 验证是否为竖屏
#define IMS_SCREEN_IS_PORTRAIT ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

#define IMS_HEXALPHACOLOR(rgbValue, a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:(a)]

#define IMS_HEXCOLOR(rgbValue) IMS_HEXALPHACOLOR(rgbValue, 1.0)

//1.根据设计图使用的手机类型尺寸，得出屏幕比
#define kHeightResult(a)   (a * IMS_SCREEN_HEIGHT / 667.0)
#define kWidthResult(b)  (b * IMS_SCREEN_WIDTH / 375.0)

// IMSFormTableViewCell.bodyView.backgroundColor
#define kEnabledCellBodyBackgroundColor IMS_HEXCOLOR(0xFFFFFF)
#define kDisabledCellBodyBackgroundColor IMS_HEXCOLOR(0xEFEFEF)

// defaultTintColor
#define kIMSFormDefaultTintHexColor @"0xFFC24B"
// global form tintColor key
#define kIMSFormGlobalTintColorKey @"IMSFormTintHexColor"

/**
 合成弱引用/强引用
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#endif /* IMSFormMacros_h */
