//
//  WBPhotoDetailsViewController.m
//  whiteboard
//
//  Created by prs-fueled on 9/19/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsViewController.h"
#import "WBPhotoTimelineSectionHeaderView.h"
#import "UIImageView+WBImageLoader.h"
#import "KeyboardAnimationView.h"
#import "WBPhotoDetailsCellPhoto.h"
#import "WBPhotoDetailsCellLikes.h"
#import "WBPhotoDetailsCellComment.h"
#import "WBPhotoDetailsCellAddComment.h"

#import "WBComment.h"
#import "WBUser.h"

@interface WBPhotoDetailsViewController () <UITableViewDataSource, UITableViewDelegate, WBPhotoTimelineSectionHeaderViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *comments;
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

  [self setupView];
  [self setupDummyData];
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

- (void)setupDummyData {
  self.comments = [NSMutableArray array];
  
  for(NSInteger i = 0; i < 10; i++){
    WBComment *comment = [[WBComment alloc] init];
    comment.createdAt = [NSDate date];
    comment.text = [NSString stringWithFormat:@"Comment text %i", i];
    
    WBUser *user = [[WBUser alloc] init];
    user.username = [NSString stringWithFormat:@"User %i", arc4random()];
    user.avatar = [NSURL URLWithString:@"http://lorempixel.com/400/400/people/"];
    
    comment.author = user;
    
    [self.comments addObject:comment];
  }
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
  
  sectionHeaderView.date = self.photo.createdAt;
  [sectionHeaderView.profilePictureImageView setImageWithPath:self.photo.author.avatar.absoluteString
                                                  placeholder:nil];
  sectionHeaderView.delegate = self;
  
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
//      WBComment *comment = [self.comments objectAtIndex:indexPath.row];
      
      return [WBPhotoDetailsCellComment cellHeightWithMessage:@"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley."];
//      return [WBPhotoDetailsCellComment cellHeight];
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

      #warning Test objects. Remove this for production
      NSMutableArray *array = [NSMutableArray array];
      for (NSInteger i = 0; i < 10; i++) {
        WBUser *user = [[WBUser alloc] init];
        user.avatar = [NSURL URLWithString:@"http://lorempixel.com/400/400/people/"];
        [array addObject:user];
      }
      
      likesCell.likers = array;
      
      break;
    }
      
    case DetailsCellTypeComments: {
      WBPhotoDetailsCellComment *commentCell = (WBPhotoDetailsCellComment *)cell;
      
      // The self.comments array doesn't start at indexPath.row because of the likes cell and photo cell.
      // Therefore we have to create an offset
      NSInteger commentsOffset = kNumberOfPhotoCells + kNumberOfLikesCells;
      
      WBComment *comment = [self.comments objectAtIndex:indexPath.row - commentsOffset];
      
      // Set the avatar
      [commentCell.avatarImageView setImageWithPath:comment.author.avatar.absoluteString placeholder:nil];
      
      // Set name
      commentCell.name = comment.author.username;
      
      // Set message
      commentCell.message = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley.";
      
      // Set date
      commentCell.createdAt = comment.createdAt;
      
      break;
    }
      
    case DetailsCellTypeAddComment: {

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
  NSInteger numberOfCommentsCells = self.comments.count;
  
  return kNumberOfPhotoCells + kNumberOfLikesCells + numberOfCommentsCells + kNumberOfAddCommentCells;
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
