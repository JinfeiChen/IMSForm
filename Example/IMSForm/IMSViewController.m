//
//  IMSViewController.m
//  IMSForm
//
//  Created by jinfei_chen@icloud.com on 12/30/2020.
//  Copyright (c) 2020 jinfei_chen@icloud.com. All rights reserved.
//

#import "IMSViewController.h"

#import <IMSForm/IMSFormType.h>

@interface IMSViewController ()

@end

@implementation IMSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", IMSFormType_TextField);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
