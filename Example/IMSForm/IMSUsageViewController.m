//
//  IMSUsageViewController.m
//  IMSForm_Example
//
//  Created by cjf on 22/2/2021.
//  Copyright © 2021 jinfei_chen@icloud.com. All rights reserved.
//

#import "IMSUsageViewController.h"
#import <WebKit/WebKit.h>

@interface IMSUsageViewController ()

@property (strong, nonatomic) IBOutlet WKWebView *webview;

@end

@implementation IMSUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"usage.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [self.webview loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
