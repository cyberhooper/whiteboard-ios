//
//  ProfileViewController.m
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "ProfileViewController.h"
#import "MainFeedCell.h"
#import "WBProfileHeaderView.h"
#import "WBDataSource.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  WBProfileHeaderView *headerView = nil;
  
  // Find the Section Header Nib
  NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WBProfileHeaderView class])
                                                      owner:nil
                                                    options:nil];
  
  for (id object in nibObjects) {
    if ([object isKindOfClass:[WBProfileHeaderView class]]) {
      headerView = (WBProfileHeaderView *)object;
    #warning set the current user
    }
  }
  
  self.tableView.tableHeaderView = headerView;
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 296.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  //warning MAGIC NUMBER. REPLACE ME
  return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterrInSection:(NSInteger)section {
  //warning MAGIC NUMBER. REPLACE ME
  return 30.0f;
}

- (NSString *)tableCellNib {
  return NSStringFromClass([MainFeedCell class]);
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
