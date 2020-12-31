//
//  UIImage+Bundle.m
//  IMSForm
//
//  Created by cjf on 2019/5/23.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

+ (UIImage *)bundleImageWithNamed:(NSString *)imageName
{
    NSBundle *resouceBundle = [self bundleWithResourceName:@"IMSForm"];
    
    return [UIImage imageNamed:imageName inBundle:resouceBundle compatibleWithTraitCollection:nil];
}

+ (NSBundle *)bundleWithResourceName:(NSString *)resourceName
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:resourceName withExtension:@"bundle"];
    NSBundle *resouceBundle = [NSBundle bundleWithURL:url];
    
    return resouceBundle;
}
@end
