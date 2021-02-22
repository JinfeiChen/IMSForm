//
//  UITableView+placeholder.m
//  caricature
//
//  Created by cjf on 2019/8/26.
//

#import "UITableView+placeholder.h"

#import <objc/runtime.h>

static NSString *kPlaceholderViewObserveKeyPath = @"frame";

@implementation UITableView (placeholder)

void swizzMethod(SEL oriSel, SEL newSel)
{
    Class class = [UITableView class];
    Method oriMethod = class_getInstanceMethod(class, oriSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    
    BOOL success = class_addMethod(class, oriSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (success) {
        class_replaceMethod(class, newSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
}

+ (void)load {
    SEL selectors[] = {
        @selector(reloadData),
        
        //        @selector(insertSections:withRowAnimation:),
        //        @selector(deleteSections:withRowAnimation:),
        //        @selector(reloadSections:withRowAnimation:),
        //        @selector(insertRowsAtIndexPaths:withRowAnimation:),
        //        @selector(deleteRowsAtIndexPaths:withRowAnimation:),
        //        @selector(reloadRowsAtIndexPaths:withRowAnimation:),
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"CJF_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        swizzMethod(originalSelector, swizzledSelector);
    }
}

- (void)CJF_reloadData {
    [self CJF_reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(placeholderView)]) {
        UIView *placeholderView = [self.delegate performSelector:@selector(placeholderView)];
        self.backgroundView = placeholderView?:[UIView new];
    }
}

#pragma mark - Setter & Getter

- (void)setPlaceholderStyle:(CJFTableViewPlaceholderStyle)placeholderStyle
{
    objc_setAssociatedObject(self, @selector(placeholderStyle), @(placeholderStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (CJFTableViewPlaceholderStyle)placeholderStyle
{
    return [objc_getAssociatedObject(self, @selector(placeholderStyle)) intValue];
}

@end
