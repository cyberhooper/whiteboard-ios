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

@interface ProfileViewController () {
  WBProfileHeaderView *headerView;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  headerView = nil;
  // Find the Section Header Nib
  NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WBProfileHeaderView class])
                                                      owner:nil
                                                    options:nil];
  
  for (id object in nibObjects) {
    if ([object isKindOfClass:[WBProfileHeaderView class]]) {
      headerView = (WBProfileHeaderView *)object;
      [self setupDataForUser:[self user]];
    }
  }
  
  self.tableView.tableHeaderView = headerView;
  
}

- (void)setupDataForUser:(WBUser *)user {
  [headerView setUpViewWithUser:user];
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

- (void)refreshPhotos {
#pragma TODO get the pictures for the property user

}

@end
