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
  if (self.loadMore && self.photos.count != 0){
    // Load more section
    return self.photos.count + 1;
  }
  
  return self.photos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  #warning MAGIC NUMBER. REPLACE ME
  if ([self isLoadMoreCell:indexPath.section]) {
    // Load More Section
    return 44.0f;
  }
  return 296.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  #warning MAGIC NUMBER. REPLACE ME
  if ([self isLoadMoreCell:section]) {
    // Load More section
    return 0.0f;
  }
  return 44.0f;
}

- (NSString *)tableCellNib {
  return NSStringFromClass([MainFeedCell class]);
}

@end
