//
//  ActivityViewController.m
//  whiteboard
//
//  Created by ttg-fueled on 9/20/13.
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

   return [self configureCell:[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier]
    forRowAtIndexPath:indexPath];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 66;
}

- (WBActivityCell *)configureCell:(WBActivityCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  
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
  
  [cell.nameButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
  [cell.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
  
//  CGSize nameSize = [cell.nameButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}];
//  
//  [cell.nameButton setFrame:CGRectMake(46.0,
//                                       8.0,
//                                       nameSize.width,
//                                       nameSize.height)];
//  if (nameSize.width <= 200) {
//    // Layout the content
//    CGSize contentSize = [cell.contentLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
//    [cell.contentLabel setNumberOfLines:1];
//    [cell.contentLabel setFrame:CGRectMake(nameSize.width + 50,
//                                           7.0,
//                                           contentSize.width,
//                                           contentSize.height)];
//  }
//  else {
//    CGSize contentSize = [cell.contentLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
//    [cell.contentLabel setNumberOfLines:2];
//    [cell.contentLabel setFrame:CGRectMake(nameSize.width,
//                                           7.0,
//                                           contentSize.width,
//                                           contentSize.height)];
//  }
//  
//  // Layout the timestamp label
//  CGSize timeSize = [cell.timeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}];
//  [cell.timeLabel setFrame:CGRectMake(46,
//                                      cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height,
//                                      timeSize.width,
//                                      timeSize.height)];
  [cell setNeedsDisplay];

  return cell;
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
