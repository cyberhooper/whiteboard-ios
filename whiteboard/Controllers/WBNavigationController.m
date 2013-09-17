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
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setUpView];
}

- (void)setUpView {
  // Set background image
  [self.navigationBar setBackgroundImage:[[WBTheme sharedTheme] navBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
  
  // Create right bar button (Settings)
  UIImage *settingsButtonBackgroundImage = [[WBTheme sharedTheme] navBarSettingsButtonBackgroundImage];

  UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
  settingsButton.frame = CGRectMake( 0, 0, settingsButtonBackgroundImage.size.width, settingsButtonBackgroundImage.size.height );
  [settingsButton setBackgroundImage:settingsButtonBackgroundImage forState:UIControlStateNormal];
  [settingsButton setImage:[[WBTheme sharedTheme] navBarSettingsButtonImage] forState:UIControlStateNormal];
  [settingsButton setImage:[[WBTheme sharedTheme] navBarSettingsButtonHighlightedImage] forState:UIControlStateHighlighted];
  
  UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
  self.topViewController.navigationItem.rightBarButtonItem = settingsBarButtonItem;
  
  // Add title
  self.topViewController.navigationItem.title = NSLocalizedString(@"NavBarTitle", @"Whiteboard");
  
  // Set font and color
  [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [[WBTheme sharedTheme] navBarTitleFontColor], NSFontAttributeName : [[WBTheme sharedTheme] navBarTitleFont]}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
