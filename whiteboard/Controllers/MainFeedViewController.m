//
//  MainFeedViewController.m
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "MainFeedViewController.h"
#import "MainFeedCell.h"
#import "WBDataSource.h"
#import "WBAccountManager.h"

@interface TestObject : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSURL *photoUrl;
@end

@interface MainFeedViewController ()

@end

@implementation MainFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
  //[super viewDidLoad];

  //[self dummyData];
  if (![[WBDataSource sharedInstance] currentUser].userID) {
    [self showLoginScreen];
  }
  
  self.loadMore = YES;
}

- (void)dummyData {
  [[WBAccountManager sharedInstance] loginWithUsername:@"testUser" andPassWord:@"test" success:^(WBUser *user) {
    NSLog(@"Logged in with user :%@", user);
  } failure:^(NSError *error) {
    NSLog(@"Loggin in failed :%@",error);
  }];
  
//  // Add dummy data
//  NSMutableArray *array = [NSMutableArray array];
//  for(NSInteger i = 1; i < 8; i++){
//    NSString *image = [NSString stringWithFormat:@"http://static.ddmcdn.com/gif/smart-car-%i.jpg", i];
//    NSString *username = [NSString stringWithFormat:@"Test %i", i];
//    
//    NSDictionary *dict = @{@"photoUrl": image, @"username": username};
//    [array addObject:dict];
//  }
//  
//  self.photos = array;
  
//  /// TEST get latest photos
//  [[WBDataSource sharedInstance] latestPhotos:^(NSArray *photos) {
//    for (WBPhoto *p in photos) {
//      // Build feed here.
//    }
//  } failure:^(NSError *error) {
//    //Error
//    NSLog(@"Error: %@ %@", error, [error userInfo]);
//  } progress:^(int percentDone) {
//    NSLog(@"Uploading : %d %@",percentDone, @"%");
//  }];

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
  if ([self isLoadMoreCell:indexPath.section]) {
    // Load More Section
    return 44.0f;
  }
  
  return 296.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([self isLoadMoreCell:section]) {
    // Load More section
    return 0.0f;
  }
  
//warning MAGIC NUMBER. REPLACE ME
  return 44.0f;
}

- (NSString *)tableCellNib {
  return NSStringFromClass([MainFeedCell class]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
