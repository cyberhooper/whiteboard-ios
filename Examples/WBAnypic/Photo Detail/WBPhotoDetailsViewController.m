//
//  WBPhotoDetailsViewController.m
//  whiteboard
//
//  Created by prs-fueled on 9/19/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsViewController.h"
#import "WBNavigationController.h"
#import "WBPhotoTimelineSectionHeaderView.h"
#import "UIImageView+WBImageLoader.h"
#import "KeyboardAnimationView.h"
#import "WBPhotoDetailsCellPhoto.h"
#import "WBPhotoDetailsCellLikes.h"
#import "WBPhotoDetailsCellComment.h"
#import "WBPhotoDetailsCellAddComment.h"
#import "WBPhoto+Utils.h"

#import "Whiteboard.h"
#import "ProfileViewController.h"

@interface WBPhotoDetailsViewController () <UITableViewDataSource, UITableViewDelegate, WBPhotoTimelineSectionHeaderViewDelegate, WBPhotoDetailsCellLikesDelegate, WBPhotoDetailsCellAddCommentDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL isLiking;
@end

typedef enum {
  DetailsCellTypeNoCell = -1,
  DetailsCellTypePhoto = 0,
  DetailsCellTypeLikes,
  DetailsCellTypeComments,
  DetailsCellTypeAddComment
}DetailsCellType;

@implementation WBPhotoDetailsViewController

#define kNumberOfPhotoCells 1
#define kNumberOfLikesCells 1
#define kNumberOfAddCommentCells 1

static NSString *PhotoCellIdentifier = @"PhotoCellIdentifier";
static NSString *LikesCellIdentifier = @"LikesCellIdentifier";
static NSString *CommentsCellIdentifier = @"CommentsCellIdentifier";
static NSString *AddCommentCellIdentifier = @"AddCommentCellIdentifier";

- (void)viewDidLoad {
  [super viewDidLoad];
  [(WBNavigationController *)[self parentViewController] showSettingsButton:NO];
  [self setupView];
  [self setUpActivityButton];
  
  [[WBDataSource sharedInstance] fetchPhoto:self.photo success:^(WBPhoto *fetchedPhoto) {
    self.photo = fetchedPhoto;
    [self.tableView reloadData];
    [self.photo setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:self.photo.url]]];
  } failure:^(NSError *error) {
  }];
}

#pragma mark - Setup
- (void)setupView {
  // Register nibs
  
  // Photo cell
  UINib *photoCellNib = [UINib nibWithNibName:
                         NSStringFromClass([WBPhotoDetailsCellPhoto class]) bundle:nil];
  [self.tableView registerNib:photoCellNib forCellReuseIdentifier:PhotoCellIdentifier];
  
  // Like cell
  UINib *likesCellNib = [UINib nibWithNibName:
                         NSStringFromClass([WBPhotoDetailsCellLikes class]) bundle:nil];
  [self.tableView registerNib:likesCellNib forCellReuseIdentifier:LikesCellIdentifier];
  
  // Comments cell
  UINib *commentsCellNib = [UINib nibWithNibName:
                            NSStringFromClass([WBPhotoDetailsCellComment class]) bundle:nil];
  [self.tableView registerNib:commentsCellNib forCellReuseIdentifier:CommentsCellIdentifier];
  
  // Add comment cell
  UINib *addCommentCellNib = [UINib nibWithNibName:
                              NSStringFromClass([WBPhotoDetailsCellAddComment class]) bundle:nil];
  [self.tableView registerNib:addCommentCellNib forCellReuseIdentifier:AddCommentCellIdentifier];
  
}

- (void)setUpActivityButton {
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                         target:self
                                                                                         action:@selector(activityButtonAction:)];
  
}

- (void)activityButtonAction:(id)sender {
  [self showShareSheet];
}

#pragma mark - ()

- (void)showShareSheet {
  
  NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
  
  if (self.photo.image == nil) {
    [self.photo setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:self.photo.url]]];
  }
  [activityItems addObject:self.photo.image];
  
  UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
  [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - UITableView
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
  
  sectionHeaderView.author = self.photo.author;
  sectionHeaderView.date = self.photo.createdAt;
  [sectionHeaderView.profilePictureImageView setImageWithPath:self.photo.author.avatar.absoluteString
                                                  placeholder:nil];
  sectionHeaderView.delegate = self;
  sectionHeaderView.sectionIndex = @(section);
  return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  //warning MAGIC NUMBER. REPLACE ME
  return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self numberOfTotalRows];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch ([self detailsTypeForIndexPath:indexPath]) {
    case DetailsCellTypePhoto:
      return [WBPhotoDetailsCellPhoto cellHeight];
      break;
      
    case DetailsCellTypeLikes:
      return [WBPhotoDetailsCellLikes cellHeight];
      break;
      
    case DetailsCellTypeComments: {
      WBComment *comment = [self commentForIndexPath:indexPath];
      return comment.text ? [WBPhotoDetailsCellComment cellHeightWithMessage:comment.text] : 0;
      break;
    }
    case DetailsCellTypeAddComment:
      return [WBPhotoDetailsCellAddComment cellHeight];
      break;
      
    default:
      return 0.f;
      break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell;
  
  switch ([self detailsTypeForIndexPath:indexPath]) {
    case DetailsCellTypePhoto:
      cell = (WBPhotoDetailsCellPhoto*)[tableView dequeueReusableCellWithIdentifier:PhotoCellIdentifier];
      break;
      
    case DetailsCellTypeLikes:
      cell = (WBPhotoDetailsCellLikes *)[tableView dequeueReusableCellWithIdentifier:LikesCellIdentifier];
      break;
      
    case DetailsCellTypeComments:
      cell = (WBPhotoDetailsCellComment *)[tableView dequeueReusableCellWithIdentifier:CommentsCellIdentifier];
      break;
      
    case DetailsCellTypeAddComment:
      cell = (WBPhotoDetailsCellAddComment *)[tableView dequeueReusableCellWithIdentifier:AddCommentCellIdentifier];
      break;
      
    default:
      return nil;
      break;
  }
  
  [self configureCell:cell forRowAtIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  switch ([self detailsTypeForIndexPath:indexPath]) {
    case DetailsCellTypePhoto: {
      WBPhotoDetailsCellPhoto *photoCell = (WBPhotoDetailsCellPhoto *)cell;
      [photoCell.photoImageView setImageWithPath:self.photo.url.absoluteString
                                     placeholder:[[WBTheme sharedTheme] feedPlaceholderImage]];
      break;
    }
    case DetailsCellTypeLikes: {
      WBPhotoDetailsCellLikes *likesCell = (WBPhotoDetailsCellLikes *)cell;
      likesCell.likers = self.photo.likes;
      likesCell.delegate = self;
      likesCell.isLiked = [self.photo isLiked];
      NSLog(@"isLiked = %d", likesCell.isLiked);
      likesCell.likeButton.button.enabled = !self.isLiking;
      
      break;
    }
    case DetailsCellTypeComments: {
      WBPhotoDetailsCellComment *commentCell = (WBPhotoDetailsCellComment *)cell;
      WBComment *comment = [self commentForIndexPath:indexPath];
      [commentCell.avatarImageView setImageWithPath:comment.author.avatar.absoluteString placeholder:nil];
      commentCell.name = comment.author.displayName;
      commentCell.message = comment.text;
      commentCell.createdAt = comment.createdAt;
      break;
    }
    case DetailsCellTypeAddComment: {
      WBPhotoDetailsCellAddComment *commentCell = (WBPhotoDetailsCellAddComment *)cell;
      commentCell.delegate = self;
      break;
    }
    default:
      break;
  }
}

- (DetailsCellType)detailsTypeForIndexPath:(NSIndexPath *)indexPath {
  
  // Return the |DetailsCellType|
  if(indexPath.row == 0){
    return DetailsCellTypePhoto;
  }else if(indexPath.row == 1){
    return DetailsCellTypeLikes;
  }else if(indexPath.row == [self numberOfTotalRows] - 1){
    return DetailsCellTypeAddComment;
  }else{
    // Otherwise the |DetailsCellType| is a comment cell
    return DetailsCellTypeComments;
  }
  
  return DetailsCellTypeNoCell;
}

- (NSInteger)numberOfTotalRows {
  NSInteger numberOfCommentsCells = self.photo.comments.count;
  
  return kNumberOfPhotoCells + kNumberOfLikesCells + numberOfCommentsCells + kNumberOfAddCommentCells;
}

#pragma mark - Config
- (UIImage *)backgroundImage {
  return [[WBTheme sharedTheme] backgroundImage];
}

#pragma mark - Likes Cell Delegate

- (void)likesCellDidSelectAvatarAtIndex:(NSUInteger)index {
  WBUser *user = self.photo.likes[index];
  [self pushProfile:user];
}

- (void)likesCellDidTapLikeButton {
  self.isLiking = YES;
  [self.tableView reloadData];
  [self toggleLikeOnPhoto:self.photo completion:^{
    self.isLiking = NO;
    [self.tableView reloadData];
  }];
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

#pragma mark - SectionHeaderView Delegate

- (void)sectionHeaderPressed:(WBUser *)author {
  [self pushProfile:author];
}

#pragma mark - Comment Cell Delegate

- (void)commentCell:(WBPhotoDetailsCellAddComment *)cell
 didTapSendWithText:(NSString *)text {
  [[WBDataSource sharedInstance] addComment:text onPhoto:self.photo success:^{
    [cell clearTextField];
    
    WBComment *comment = [[WBComment alloc] init];
    comment.author = [[WBDataSource sharedInstance] currentUser];
    comment.text = text;
    comment.createdAt = [NSDate date];
    
    self.photo.comments = [self.photo.comments arrayByAddingObject: comment];
    
    [self.tableView reloadData];
  } failure:^(NSError *error) {
    
  }];
}

#pragma mark - Helpers
- (void)pushProfile:(WBUser *)user {
  ProfileViewController *profileVC = [[ProfileViewController alloc] init];
  profileVC.user = user;
  [self.navigationController pushViewController:profileVC animated:YES];
}

- (WBComment *)commentForIndexPath:(NSIndexPath *)indexPath {
  // The self.comments array doesn't start at indexPath.row because of the likes cell and photo cell.
  // Therefore we have to create an offset
  NSInteger commentsOffset = kNumberOfPhotoCells + kNumberOfLikesCells;
  WBComment *comment = [self.photo.comments objectAtIndex:indexPath.row - commentsOffset];
  return comment;
}

@end
