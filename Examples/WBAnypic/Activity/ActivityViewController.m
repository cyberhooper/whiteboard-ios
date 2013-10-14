//
//  ActivityViewController.m
//  whiteboard
//
//  Created by ttg-fueled on 9/20/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "ActivityViewController.h"
#import "UIImageView+WBImageLoader.h"
#import "Whiteboard.h"
#import "WBActivityCell.h"
#import "WBPhotoDetailsViewController.h"
#import "ProfileViewController.h"

static const float kCellHeight = 66.0f;

@interface ActivityViewController ()
@property NSArray *activities;
@end

@implementation ActivityViewController
static NSString *tableCellIdentifier = @"WBActivityCell";

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView setDelegate:self];
  [self.tableView setDataSource:self];
  UINib *tableCellNib = [UINib nibWithNibName:[self tableCellNib] bundle:nil];
  [self.tableView registerNib:tableCellNib
       forCellReuseIdentifier:tableCellIdentifier];
  [self.tableView setBackgroundColor:[UIColor clearColor]];
  
  self.activities = [[NSArray alloc]init];
  
  [[WBDataSource sharedInstance] recentActivities:^(NSArray *activities) {
    self.activities = activities;
    [self.tableView reloadData];
  } failure:nil];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.activities count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   return [self configureCell:[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier] forRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return kCellHeight;
}

- (WBActivityCell *)configureCell:(WBActivityCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  WBActivity *activity = ((WBActivity *)[self.activities objectAtIndex:indexPath.row]);
  [cell.nameButton setTitle:activity.fromUser.displayName forState:UIControlStateNormal];
  CALayer *layer = [cell.avatarImageView layer];
  layer.cornerRadius = 3.0f;
  layer.masksToBounds = YES;
  [cell setDelegate:self];
  [cell setDate:activity.createdAt];

  if (activity.fromUser.avatar == nil) {
    cell.avatarImageView.image = nil;
  }
  else {
  [cell.avatarImageView setImageWithPath:activity.fromUser.avatar.absoluteString
                             placeholder:nil];
  }
  
  if (activity.photo) {
    [cell.photoImageView setImageWithPath:activity.photo.url.absoluteString
                              placeholder:nil];
  }
  
  [cell.contentLabel setText:[self contentTextForActivityType:activity.type]];
  
  [cell.nameButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
  [cell.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  WBActivity *activity = ((WBActivity *)[self.activities objectAtIndex:indexPath.row]);
  if ([activity.type isEqualToString:@"like"] || [activity.type isEqualToString:@"comment"]) {
    [self pushPhotoDetailViewWhithPhoto:[activity photo]];
  }
  else if ([activity.type isEqualToString:@"follow"]) {
    [self pushProfileViewWithUser:[activity fromUser]];
  }
}

- (void)fromUserProfilePressed:(WBActivityCell *)cell {
  WBActivity *activity = ((WBActivity *)[self.activities objectAtIndex:[self.tableView indexPathForCell:cell].row]);
  [self pushProfileViewWithUser:[activity fromUser]];

}

- (void)pushProfileViewWithUser:(WBUser *)user {
  ProfileViewController *profileVC = [[ProfileViewController alloc] init];
  profileVC.user = user;
  [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)pushPhotoDetailViewWhithPhoto:(WBPhoto *)photo {
  WBPhotoDetailsViewController *photoDetailsVC = [[WBPhotoDetailsViewController alloc] init];
  photoDetailsVC.photo = photo;
  [self.navigationController pushViewController:photoDetailsVC animated:YES];
}

- (NSString *)contentTextForActivityType:(NSString *)type {
  if ([type  isEqualToString:@"like"]) {
    return @"liked your photo";
  }else if ([type isEqualToString:@"comment"]) {
    return @"commented your photo";
  } else if ([type isEqualToString:@"follow"]) {
    return @"started following you";
  }
  return nil;
}

- (UIImage *)backgroundImage {
  return [[WBTheme sharedTheme] backgroundImage];
}

- (NSString *)tableCellNib {
  return NSStringFromClass([WBActivityCell class]);
}

@end
