//
//  MainFeedViewController.m
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "MainFeedViewController.h"
#import "MainFeedCell.h"
#import "Whiteboard.h"

static const float kCellHeight = 296.f;
static const float kHeaderHeight = 44.0f;

static const float kLoadMoreCellHeight = 44.0f;
static const float kLoadMoreHeaderHeight = 0.0f;

@implementation MainFeedViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  if (![[WBDataSource sharedInstance] currentUser].userID) {
    [self showLoginScreen];
  }
  
  self.loadMore = YES;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  BOOL hasMoreItemsToLoad = self.loadMore && self.photos.count != 0;
  return hasMoreItemsToLoad ? self.photos.count + 1 : self.photos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self isLoadMoreCell:indexPath.section] ? kLoadMoreCellHeight : kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return [self isLoadMoreCell:section] ? kLoadMoreHeaderHeight : kHeaderHeight;
}

- (NSString *)tableCellNib {
  return NSStringFromClass([MainFeedCell class]);
}

@end
