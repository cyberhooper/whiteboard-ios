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
  self.loadMore = YES;

}

- (void)setupDataForUser:(WBUser *)user {
  [headerView setUpViewWithUser:user];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.loadMore && self.photos.count != 0){
    // Load more section
    return self.photos.count + 1;
  }
  
  return self.photos.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self isLoadMoreCell:indexPath.section]) {
    // Load More Section
    return 44.0f;
  }
  
  return 296.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([self isLoadMoreCell:section]) {
    // Load More section
    return 0.0f;
  }
  
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
  [[WBDataSource sharedInstance] photosForUser:[self user]
                                    withOffset:0
                                       success:^(NSArray *photos) {
                                      self.photoOffset = photos.count;
                                      self.photos = photos;
                                      
                                      // If the number of returned objects is less than the photoLimit then don't show the loadMore cell
                                      if(photos.count < [[WBDataSource sharedInstance] photoLimit]){
                                        self.loadMore = NO;
                                      }else{
                                        self.loadMore = YES;
                                      }
                                      
                                      [self.tableView reloadData];
                                      self.isLoading = NO;

                                    } failure:^(NSError *error) {
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Refresh Failed"
                                                                                      message:[error description]
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles:nil];
                                      [alert show];
                                      self.isLoading = NO;

                                    }];
}

@end
