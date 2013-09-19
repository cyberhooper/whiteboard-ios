//
//  WBPhotoDetailsViewController.m
//  whiteboard
//
//  Created by prs-fueled on 9/19/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsViewController.h"

@interface WBPhotoDetailsViewController ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation WBPhotoDetailsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  
}

#pragma mark - Config
- (UIImage *)backgroundImage {
  return [[WBTheme sharedTheme] backgroundImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
