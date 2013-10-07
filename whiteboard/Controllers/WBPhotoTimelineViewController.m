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
#import "UIImageView+WBImageLoader.h"
#import "WBDataSource.h"
#import "WBLoginViewController.h"
#import "WBLoadMoreCell.h"
#import "ProfileViewController.h"
#import "WBPhoto+Utils.h"
#import "WBPhotoDetailsViewController.h"

@interface WBPhotoTimelineViewController () <WBPhotoTimelineSectionHeaderViewDelegate>
@property (nonatomic, strong) NSMutableArray *photosBeeingLiked;
@end

@implementation WBPhotoTimelineViewController

static NSString *tableCellIdentifier = @"WBPhotoTimelineCell";
static NSString *loadMoreCellIdentifier = @"WBLoadMoreCell";

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupView];
  [self refreshPhotos];
  [self setupRefreshControl];
}

#pragma mark - Setup
- (void)setupView {
  // Setup table cell NIB
  UINib *tableCellNib = [UINib nibWithNibName:[self tableCellNib] bundle:nil];
  [self.tableView registerNib:tableCellNib forCellReuseIdentifier:tableCellIdentifier];
  
  // Setup load more cell NIB
  UINib *loadMoreCellNib = [UINib nibWithNibName:[self loadMoreTableCellNib] bundle:nil];
  [self.tableView registerNib:loadMoreCellNib forCellReuseIdentifier:loadMoreCellIdentifier];
  
  // Defaults
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
  if ([self isLoadMoreCell:section]) {
    // Load More section
    return nil;
  }
  
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
  sectionHeaderView.author = photo.author;
  sectionHeaderView.date = photo.createdAt;
  [sectionHeaderView.profilePictureImageView setImageWithPath:photo.author.avatar.absoluteString
                                                  placeholder:nil];
  sectionHeaderView.numberOfLikes = @(photo.likes.count);
  sectionHeaderView.numberOfComments = @(photo.comments.count);
  sectionHeaderView.delegate = self;
  sectionHeaderView.sectionIndex = @(section);
  sectionHeaderView.isLiked = [photo isLiked];
  sectionHeaderView.likeButton.button.enabled = ![self isBeeingLiked:photo];
  
  return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([self isLoadMoreCell:section]) {
    // Load More section
    return 0.0f;
  }
  
  //warning MAGIC NUMBER. REPLACE ME
  return 44.0f;
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if(indexPath.section == self.photos.count){
    // Load More cell
    return [self tableView:tableView cellForLoadMoreAtIndexPath:indexPath];
  }
  
  WBPhotoTimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
  
  [self configureCell:cell forRowAtIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(WBPhotoTimelineCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  WBPhoto *photo = ((WBPhoto *)[self.photos objectAtIndex:indexPath.section]);
  // Set the cell image
  [cell.photoImageView setImageWithPath:photo.url.absoluteString placeholder:[[WBTheme sharedTheme] feedPlaceholderImage]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self isLoadMoreCell:indexPath.section]) {
    // Load More Cell
    [self loadNextPage];
    return;
  }
  
  WBPhoto *photo = ((WBPhoto *)[self.photos objectAtIndex:indexPath.section]);
  
  [self pushPhotoDetailsViewWithPhoto:photo];
}

- (void)pushPhotoDetailsViewWithPhoto:(WBPhoto *)photo {
  WBPhotoDetailsViewController *photoDetailsVC = [[WBPhotoDetailsViewController alloc] init];
  photoDetailsVC.photo = photo;
  [self.navigationController pushViewController:photoDetailsVC animated:YES];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.backgroundColor = [UIColor clearColor];
  cell.contentView.backgroundColor = [UIColor clearColor];
  cell.backgroundView.backgroundColor = [UIColor clearColor];
}

#pragma mark - LoadMoreCell
- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForLoadMoreAtIndexPath:(NSIndexPath *)indexPath {
  
  WBLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:loadMoreCellIdentifier];
  
  [self configureLoadMoreCell:cell forRowAtIndexPath:indexPath];
  
  return cell;
}

- (void)configureLoadMoreCell:(WBLoadMoreCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  // Set load more image
  cell.loadMoreImage = [[WBTheme sharedTheme] feedLoadMoreImage];
  
  // Set seperator top
  cell.seperatorTopImage = [[WBTheme sharedTheme] feedLoadMoreSeperatorTopImage];
}

- (BOOL)isLoadMoreCell:(NSInteger)row {
  return row == self.photos.count && self.loadMore;
}

- (void)loadNextPage {
  [[WBDataSource sharedInstance] latestPhotosWithOffset:self.photoOffset success:^(NSArray *photos) {
    // If we receive nothing in return then set loadMore to NO.
    if(photos.count == 0){
      self.loadMore = NO;
      return;
    }
    
    self.photoOffset += photos.count;
    self.photos = [self.photos arrayByAddingObjectsFromArray:photos];
    [self.tableView reloadData];
  } failure:nil];
}

- (void)setLoadMore:(BOOL)loadMore {
  _loadMore = loadMore;
  
  // If loadMore is set to NO and there are exists objects then reload the tableview
  if(!_loadMore){
    [self.tableView reloadData];
  }
}

#pragma mark - Config
- (NSString *)tableCellNib {
  return NSStringFromClass([WBPhotoTimelineCell class]);
}

- (NSString *)loadMoreTableCellNib {
  return NSStringFromClass([WBLoadMoreCell class]);
}

- (UIImage *)backgroundImage {
  return [[WBTheme sharedTheme] backgroundImage];
}

- (void)setupRefreshControl {
  // Create the refresh control
  self.refreshControl = [[UIRefreshControl alloc] init];
  // Set the action
  [self.refreshControl addTarget:self action:@selector(refreshPhotos) forControlEvents:UIControlEventValueChanged];
  
  self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating data..."];
  [self.tableView addSubview:self.refreshControl];

}


- (void)refreshPhotos {
  [[WBDataSource sharedInstance] latestPhotos:^(NSArray *photos) {
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
    [alert show];
    [self.refreshControl endRefreshing];

    self.isLoading = NO;
  }];
}

#pragma mark - WBPhotoTimelineSectionHeaderViewDelegate
- (void)sectionHeaderCommentsButtonPressed:(WBPhotoTimelineSectionHeaderView *)sectionView {
  WBPhoto *photo = ((WBPhoto *)[self.photos objectAtIndex:[sectionView.sectionIndex integerValue]]);
  
  [self pushPhotoDetailsViewWithPhoto:photo];

}

- (void)sectionHeaderPressed:(WBUser *)author {
  ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:NSStringFromClass([ProfileViewController class])
                                                                                         bundle:nil];
  [profileViewController setUser:author];
  [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark - Like Management

- (void)sectionHeaderLikesButtonPressed:(WBPhotoTimelineSectionHeaderView *)sectionView {
  WBPhoto *photo = [self photoForSectionView:sectionView];
  [self.photosBeeingLiked addObject:photo];
  [self toggleLikeOnPhoto:photo completion:^{
    [self.photosBeeingLiked removeObject:photo];
    [self.tableView reloadData];
  }];
  [self.tableView reloadData]; // only reload the section concerned. for optimisation ?
}

- (WBPhoto *)photoForSectionView:(WBPhotoTimelineSectionHeaderView *)sectionView {
  return self.photos[sectionView.sectionIndex.intValue];
}

- (void)toggleLikeOnPhoto:(WBPhoto *)photo
               completion:(void(^)(void))completion {
  if ([photo isLiked])
    [self unlikePhoto:photo completion:completion];
  else
    [self likePhoto:photo completion:completion];
}

- (void)likePhoto:(WBPhoto *)photo completion:(void(^)(void))completion {
  [self addLikeOnPhoto:photo];
  [[WBDataSource sharedInstance] likePhoto:photo withUser:[WBDataSource currentUser] success:^{
    completion();
  } failure:^(NSError *error) {
    [self removeLikeOnPhoto:photo];
    [self likeFailedWithError:error];
    completion();
  }];
}

- (void)unlikePhoto:(WBPhoto *)photo completion:(void(^)(void))completion {
  [self removeLikeOnPhoto:photo];
  [[WBDataSource sharedInstance] unlikePhoto:photo withUser:[WBDataSource currentUser] success:^{
    completion();
  } failure:^(NSError *error) {
    [self addLikeOnPhoto:photo];
    [self unLikeFailedWithError:error];
    completion();
  }];
}
   
- (void)likeFailedWithError:(NSError *)error {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Like Photo Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

- (void)unLikeFailedWithError:(NSError *)error {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Un-Like Photo Failed" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

- (void)addLikeOnPhoto:(WBPhoto *)photo {
  photo.likes = [photo.likes arrayByAddingObject:[[WBDataSource sharedInstance] currentUser]];
}

- (void)removeLikeOnPhoto:(WBPhoto *)photo {
  NSMutableArray *arr = [photo.likes mutableCopy];
  [arr removeObject:[WBDataSource sharedInstance].currentUser];
  photo.likes = arr;
}

- (BOOL)isBeeingLiked:(WBPhoto *)photo {
  return [self.photosBeeingLiked containsObject:photo];
}

- (NSMutableArray *)photosBeeingLiked {
  if (!_photosBeeingLiked)
    _photosBeeingLiked = [@[] mutableCopy];
  return _photosBeeingLiked;
}

@end
