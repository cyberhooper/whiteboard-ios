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

@interface WBPhotoTimelineViewController () <WBPhotoTimelineSectionHeaderViewDelegate>

@end

@implementation WBPhotoTimelineViewController

static NSString *cellIdentifier = @"WBPhotoTimelineCell";

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
  
  [self setupView];
}

#pragma mark - Setup
- (void)setupView {
  // Setup NIB
  UINib *nib = [UINib nibWithNibName:[self tableCellNib] bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
  self.tableView.backgroundColor = [UIColor clearColor];
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
  
  sectionHeaderView.displayName = [[self.photos objectAtIndex:section] valueForKey:@"username"];
  sectionHeaderView.date = [NSDate date];
  [sectionHeaderView.profilePictureImageView setImageWithPath:[[self.photos objectAtIndex:section] valueForKey:@"photoUrl"]
                                                  placeholder:nil];
  sectionHeaderView.numberOfLikes = @2;
  sectionHeaderView.numberOfComments = @3;
  sectionHeaderView.delegate = self;
  
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
  // Set the cell image
  [cell.photoImageView setImageWithPath:[[self.photos objectAtIndex:indexPath.section] valueForKey:@"photoUrl"] placeholder:nil];
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
  return [UIImage imageNamed:@"backgroundLeather"];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
  CGFloat scrollViewHeight = scrollView.bounds.size.height;
  
  CGFloat offsetY = screenHeight - scrollViewHeight + scrollView.contentOffset.y;
  
  #warning Magic number, change this
  if(offsetY <= -60.f){
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
  
  #warning Change this. Perform fetch request
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    self.isLoading = NO;
    NSLog(@"Done refreshing...");
  });
}

#pragma mark - WBPhotoTimelineSectionHeaderViewDelegate
- (void)sectionHeaderCommentsButtonPressed:(WBPhotoTimelineSectionHeaderView *)sectionView {
  NSLog(@"Comments pressed");
}

- (void)sectionHeaderLikesButtonPressed:(WBPhotoTimelineSectionHeaderView *)sectionView {
  NSLog(@"Likes pressed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
