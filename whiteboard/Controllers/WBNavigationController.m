//
//  WBNavigationController.m
//  whiteboard
//
//  Created by lnf-fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBNavigationController.h"

@interface WBNavigationController ()

@end

@implementation WBNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  [self setUpView];
}

- (void)setUpView {
  [self.navigationBar setBackgroundImage:[[WBTheme sharedTheme] navBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
