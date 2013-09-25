//
//  ActivityViewController.m
//  whiteboard
//
//  Created by Thibault Gauche on 9/20/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "ActivityViewController.h"
#import "UIImageView+WBImageLoader.h"
#import "WBDataSource.h"
#import "WBActivityCell.h"
#import "WBActivity.h"


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
  [self.tableView registerNib:tableCellNib forCellReuseIdentifier:tableCellIdentifier];
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

  WBActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];

  [self configureCell:cell forRowAtIndexPath:indexPath];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 66;
}

- (void)configureCell:(WBActivityCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  WBActivity *activity = ((WBActivity *)[self.activities objectAtIndex:indexPath.row]);
  [cell.nameButton setTitle:activity.fromUser.displayName forState:UIControlStateNormal];
  CALayer *layer = [cell.avatarImageView layer];
  layer.cornerRadius = 3.0f;
  layer.masksToBounds = YES;
  [cell setDate:activity.createdAt];

  [cell.avatarImageView setImageWithPath:activity.fromUser.avatar.absoluteString
                             placeholder:nil];
  if (activity.photo) {
    [cell.photoImageView setImageWithPath:activity.photo.url.absoluteString
                              placeholder:nil];
  }
  
  [cell.contentLabel setText:[self contentTextForActivityType:activity.type]];
  
  [cell setUpCell];
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
