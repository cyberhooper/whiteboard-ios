//
//  ProfileViewController.m
//  whiteboard
//
//  Created by lnf-fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "ProfileViewController.h"
#import "MainFeedCell.h"
#import "WBProfileHeaderView.h"
#import "WBPhotoDetailsViewController.h"

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
#warning MAGIC NUMBER. REPLACE ME
  return 296.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
#warning MAGIC NUMBER. REPLACE ME
  return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterrInSection:(NSInteger)section {
#warning MAGIC NUMBER. REPLACE ME
  return 30.0f;
}

- (NSString *)tableCellNib {
  return NSStringFromClass([MainFeedCell class]);
}

- (void)refreshPhotos {
  [[WBDataSource sharedInstance] photosForUser:[self user]
                                    withOffset:0 success:^(NSArray *photos) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { 
  WBPhoto *photo = ((WBPhoto *)[self.photos objectAtIndex:indexPath.section]);
  WBPhotoDetailsViewController *photoDetailsVC = [[WBPhotoDetailsViewController alloc] init];
  photoDetailsVC.photo = photo;
  [self.navigationController pushViewController:photoDetailsVC animated:YES];
}

@end
