//
//  WBPhotoTimelineViewController.m
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoTimelineViewController.h"
#import "WBPhotoTimelineSectionHeaderView.h"
#import "WBPhotoTimelineCell.h"
#import "UIImageView+SLImageLoader.h"
#import "WBDataSource.h"
#import "WBLoginViewController.h"

@interface WBPhotoTimelineViewController () <WBPhotoTimelineSectionHeaderViewDelegate>

@end

@implementation WBPhotoTimelineViewController

static NSString *cellIdentifier = @"WBPhotoTimelineCell";

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupView];
  [self refreshPhotos];
}

#pragma mark - Setup
- (void)setupView {
  // Setup NIB
  UINib *nib = [UINib nibWithNibName:[self tableCellNib] bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
  self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)showLoginScreen {
  WBLoginViewController *loginVC = [[WBLoginViewController alloc]init];
  UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginVC];
  navController.navigationBarHidden = YES;
  [self presentViewController:navController animated:NO completion:nil];
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  WBPhotoTimelineSectionHeaderView *sectionHeaderView = nil;
  
  // Find the Section Header Nib
  NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:
                         NSStringFromClass([WBPhotoTimelineSectionHeaderView class])
                                                      owner:nil
                                                    options:nil];
  
  for (id object in nibObjects) {
    if ([object isKindOfClass:[WBPhotoTimelineSectionHeaderView class]]) {
      sectionHeaderView = (WBPhotoTimelineSectionHeaderView *)object;
      break;
    }
  }
  
  WBPhoto *photo = ((WBPhoto *)[self.photos objectAtIndex:section]);
  sectionHeaderView.displayName = photo.author.displayName;
  sectionHeaderView.date = photo.createdAt;
  [sectionHeaderView.profilePictureImageView setImageWithPath:photo.author.avatar.absoluteString
                                                  placeholder:nil];
  sectionHeaderView.numberOfLikes = @(photo.likes.count);
  sectionHeaderView.numberOfComments = @(photo.comments.count);
  sectionHeaderView.delegate = self;
  sectionHeaderView.sectionIndex = @(section);
  sectionHeaderView.isLiked = [photo.likes containsObject:[WBDataSource currentUser].userID];
  
  return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//warning MAGIC NUMBER. REPLACE ME
  return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.photos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  WBPhotoTimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  [self configureCell:cell forRowAtIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(WBPhotoTimelineCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  WBPhoto *photo = ((WBPhoto *)[self.photos objectAtIndex:indexPath.section]);
  // Set the cell image
  [cell.photoImageView setImageWithPath:photo.url.absoluteString placeholder:[[WBTheme sharedTheme] feedPlaceholderImage]];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.backgroundColor = [UIColor clearColor];
  cell.contentView.backgroundColor = [UIColor clearColor];
  cell.backgroundView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Config
- (NSString *)tableCellNib {
  return NSStringFromClass([WBPhotoTimelineCell class]);
}

- (UIImage *)backgroundImage {
  return [[WBTheme sharedTheme] backgroundImage];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
  CGFloat scrollViewHeight = scrollView.bounds.size.height;
  
  CGFloat offsetY = screenHeight - scrollViewHeight + scrollView.contentOffset.y;
  
  #warning Magic number, change this
  if(offsetY <= -100.f){
    [self scrollViewDidPullToRefresh:scrollView];
  }
}

#pragma mark - Refresh
- (void)scrollViewDidPullToRefresh:(UIScrollView *)scrollView {
  // Don't scroll if it's loading
  if(self.isLoading){
    return;
  }
  
  self.isLoading = YES;
  NSLog(@"Refreshing...");
  [self refreshPhotos];
}

- (void)refreshPhotos {
  [[WBDataSource sharedInstance] latestPhotos:^(NSArray *photos) {
    self.photos = photos;
    [self.tableView reloadData];
    self.isLoading = NO;
  }
                                      failure:^(NSError *error){
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Refresh Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                        self.isLoading = NO;
                                      }];
}

#pragma mark - WBPhotoTimelineSectionHeaderViewDelegate
- (void)sectionHeaderCommentsButtonPressed:(WBPhotoTimelineSectionHeaderView *)sectionView {
  NSLog(@"Comments pressed");
}

- (void)sectionHeaderLikesButtonPressed:(WBPhotoTimelineSectionHeaderView *)sectionView {
  WBPhoto *photo = ((WBPhoto *)[self.photos objectAtIndex:sectionView.sectionIndex.intValue]);
  if (![photo.likes containsObject:[WBDataSource currentUser].userID]) {
    [self likePhoto:photo completion:^(BOOL success) {
      if (success) {
        sectionView.numberOfLikes = @(sectionView.numberOfLikes.intValue + 1);
        sectionView.isLiked = YES;
      }
    }];
  } else {
    [self unlikePhoto:photo completion:^(BOOL success) {
      if (success && sectionView.numberOfLikes > 0) {
        sectionView.numberOfLikes = @(sectionView.numberOfLikes.intValue - 1);
        sectionView.isLiked = NO;
      }
    }];
  }
  NSLog(@"Likes pressed");
}

- (void)likePhoto:(WBPhoto *)photo completion:(void(^)(BOOL success))result {
  [[WBDataSource sharedInstance] likePhoto:photo withUser:[WBDataSource currentUser] success:^{
    result(YES);
  } failure:^(NSError *error) {
    result(NO);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Like Photo Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }];
}

- (void)unlikePhoto:(WBPhoto *)photo completion:(void(^)(BOOL success))result {
  [[WBDataSource sharedInstance] unlikePhoto:photo withUser:[WBDataSource currentUser] success:^{
    result(YES);
  } failure:^(NSError *error) {
    result(NO);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Un-Like Photo Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
