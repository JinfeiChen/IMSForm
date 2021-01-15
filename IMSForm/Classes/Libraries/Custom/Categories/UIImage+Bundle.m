//
//  UIImage+Bundle.m
//  IMSForm
//
//  Created by cjf on 2019/5/23.
//

#import "UIImage+Bundle.h"
#import <IMSForm/NSBundle+ims.h>

@implementation UIImage (Bundle)

+ (UIImage *)bundleImageWithNamed:(NSString *)imageName
{
    NSBundle *resouceBundle = [NSBundle bundleWithBundleName:@"IMSForm" podName:@"IMSForm"];
    return [UIImage imageNamed:imageName inBundle:resouceBundle compatibleWithTraitCollection:nil];
}

@end
