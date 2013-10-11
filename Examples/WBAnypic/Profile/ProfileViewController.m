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

static const float kRowHeight = 296.f;
static const float kHeaderHeight = 44.0f;
static const float kFooterHeight = 30.0f;

@interface ProfileViewController () {
  UIBarButtonItem *followButton;
}

@property (nonatomic, weak) WBProfileHeaderView *headerView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setUpProfileHeaderView];
  
  [[WBDataSource sharedInstance] isFollowed:self.user success:^(BOOL isFollowed) {
    if (![self.user isEqual:[WBDataSource sharedInstance].currentUser])
      [self addfollowBarButtonItem];
  } failure:nil];
}

- (void)setUpProfileHeaderView {
  self.tableView.tableHeaderView = self.headerView;
  [self updateProfileHeaderView];
}

- (void)updateProfileHeaderView {
  [self.headerView.nameLabel setText:self.user.displayName];
  [self.headerView.profilePictureImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:self.user.avatar]]];
  
  [[WBDataSource sharedInstance] numberOfFollowersForUser:self.user success:^(int numberOfFollowers) {
    self.headerView.numberFollowersLabel.text = [NSString stringWithFormat:@"%d followers", numberOfFollowers];
  } failure:nil];
  
  [[WBDataSource sharedInstance] numberOfFollowingsForUser:self.user success:^(int numberOfFollowings) {
    self.headerView.numberFollowingLabel.text = [NSString stringWithFormat:@"%d following", numberOfFollowings];
  } failure:nil];
  
  [[WBDataSource sharedInstance]numberOfPhotosForUser:self.user success:^(int numberOfPhotos) {
    self.headerView.numberPicturesLabel.text = [NSString stringWithFormat:@"%d photos", numberOfPhotos];
  } failure:nil];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return kHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterrInSection:(NSInteger)section {
  return kFooterHeight;
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
                                      [self.refreshControl endRefreshing];
                                      [self.tableView reloadData];
                                      self.isLoading = NO;

                                    } failure:^(NSError *error) {
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Refresh Failed"
                                                                                      message:[error description]
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles:nil];
                                      [self.refreshControl endRefreshing];
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

#pragma mark - Follow / Unfollow button

- (void)addfollowBarButtonItem {
  followButton = [[UIBarButtonItem alloc] initWithTitle:@"Follow"
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(toggleFollow)];
  [self refreshFollowButton];
  self.navigationItem.rightBarButtonItem = followButton;
}

- (void)toggleFollow {
  followButton.enabled = NO;
  [[WBDataSource sharedInstance] toggleFollowForUser:self.user success:^{
    [self refreshFollowButton];
  } failure:^(NSError *error) {
    [self refreshFollowButton];
  }];
}

- (void)refreshFollowButton {
  followButton.enabled = YES;
  followButton.title = self.user.isFollowed ? @"Unfollow" : @"Follow";
}

#pragma mark - Lazy instanciations

- (WBProfileHeaderView *)headerView {
  if (!_headerView)
    _headerView = [WBProfileHeaderView view];
  return _headerView;
}

@end
