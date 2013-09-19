//
//  WBFindFriendsViewController.m
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBFindFriendsViewController.h"
#import "WBDataSource.h"
#import "UIImageView+WBImageLoader.h"

@interface WBFindFriendsViewController ()

@end

@implementation WBFindFriendsViewController

static const int kInviteFriendsSectionIndex = 0;
static const int kFriendsListSectionIndex = 1;
static const int kLoadMoreSectionIndex = 2;

static NSString *cellIdentifier = @"WBFriendCell";
static NSString *loadMoreCellIdentifier = @"WBLoadMoreCell";
static NSString *inviteFriendsCellIdentifier = @"WBInviteFriendsCell";

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setUpView];
  [self getSuggestedUsers];
}

#pragma mark - Config
- (void)setUpView {
  // Set up the nav bar
  self.followAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Follow All" style:UIBarButtonItemStyleBordered target:self action:@selector(followAll)];
  self.unfollowAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Unfollow All" style:UIBarButtonItemStyleBordered target:self action:@selector(unfollowAll)];
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[[WBTheme sharedTheme] findFriendsTitleImage]];
  
  // Setup NIB
  UINib *nib = [UINib nibWithNibName:[self tableCellNib] bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
  
  // Setup load more cell NIB
  UINib *loadMoreCellNib = [UINib nibWithNibName:[self loadMoreTableCellNib] bundle:nil];
  [self.tableView registerNib:loadMoreCellNib forCellReuseIdentifier:loadMoreCellIdentifier];
  
  // Setup invite friends cell NIB
  UINib *inviteFriendsCellNib = [UINib nibWithNibName:[self inviteFriendsTableCellNib] bundle:nil];
  [self.tableView registerNib:inviteFriendsCellNib forCellReuseIdentifier:inviteFriendsCellIdentifier];
  
  self.tableView.backgroundColor = [UIColor clearColor];
  self.view.backgroundColor = [UIColor colorWithPatternImage:[[WBTheme sharedTheme] backgroundImage]];
  
  self.loadMore = YES;
}

- (void)configureBarButton {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFollowed == NO"];
  NSArray *unfollowedUsers = [self.users filteredArrayUsingPredicate:predicate];
  if (unfollowedUsers.count) {
    self.navigationItem.rightBarButtonItem = self.followAllButton;
  } else {
    self.navigationItem.rightBarButtonItem = self.unfollowAllButton;
  }
}

- (NSString *)tableCellNib {
  return NSStringFromClass([WBFriendCell class]);
}

- (NSString *)loadMoreTableCellNib {
  return NSStringFromClass([WBLoadMoreCell class]);
}

- (NSString *)inviteFriendsTableCellNib {
  return NSStringFromClass([WBInviteFriendsCell class]);
}

- (void)dummyData {
  self.users = @[@"Thibault", @"Sacha", @"Petter", @"German"];
}

- (void)getSuggestedUsers {
  [[WBDataSource sharedInstance] suggestedUsers:^(NSArray *users) {
    self.users = users;
    [self configureBarButton];
    [self.tableView reloadData];
  } failure:^(NSError *error) {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SuggestedFriendsFailed", @"Cannot Get Friends")
                               message:NSLocalizedString(@"SuggestedFriendsFailedMessage", @"Suggested friends failed. Please try again.")
                              delegate:nil
                     cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                     otherButtonTitles:nil] show];
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
  return self.loadMore ? 3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
  if (section == kInviteFriendsSectionIndex || section == kLoadMoreSectionIndex) {
    return 1;
  }
  return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == kInviteFriendsSectionIndex) {
    WBInviteFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:inviteFriendsCellIdentifier forIndexPath:indexPath];
    [self configureInviteFriendsCell:cell forRowAtIndexPath:indexPath];
    return cell;
  } else if(indexPath.section == kLoadMoreSectionIndex){
    // Load More cell
    return [self tableView:tableView cellForLoadMoreAtIndexPath:indexPath];
  }
  
  WBFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  [self configureCell:cell forRowAtIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(WBFriendCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.delegate = self;
  WBUser *user = ((WBUser *)self.users[indexPath.row]);
  cell.name = user.displayName;
  [cell.avatarImageView setImageWithPath:user.avatar.absoluteString placeholder:nil];
  cell.followButton.selected = user.isFollowed;
  cell.userIndex = @(indexPath.row);
  [[WBDataSource sharedInstance] numberOfPhotosForUser:user success:^(int numberOfPhotos) {
    cell.numPhotos = @(numberOfPhotos);
  } failure:^(NSError *error) {
    cell.numPhotos = @0;
  }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == kLoadMoreSectionIndex) {
    return 44.0f;
  }
  return [WBFriendCell heightForCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self isLoadMoreCell:indexPath.section]) {
    // Load More Cell
    [self loadNextPage];
  } else if (indexPath.section == kInviteFriendsSectionIndex) {
    [self inviteFriendsTapped];
  }
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
  cell.backgroundColor = [UIColor clearColor];
  cell.loadMoreImage = [[WBTheme sharedTheme] feedLoadMoreImage];
  
  // Set seperator top
  cell.seperatorTopImage = [[WBTheme sharedTheme] feedLoadMoreSeperatorTopImage];
}

- (BOOL)isLoadMoreCell:(NSInteger)section {
  if(!self.loadMore){
    return NO;
  }
  
  return section == kLoadMoreSectionIndex;
}

- (void)loadNextPage {
  NSLog(@"Load next page here");
}

- (void)inviteFriendsTapped {
  NSLog(@"Invite friends here");
}

#pragma mark - Invite Friends Cell
- (void)configureInviteFriendsCell:(WBInviteFriendsCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.inviteFriendsLabel.text = NSLocalizedString(@"InviteFriends", @"Invite friends");
}

#pragma mark - WBFriendCellDelegate
- (void)cell:(WBFriendCell *)cellView didTapFollowButtonAtIndex:(NSNumber *)userIndex {
  cellView.followButton.selected = !cellView.followButton.selected;
  WBUser *user = ((WBUser *)self.users[userIndex.intValue]);
  [[WBDataSource sharedInstance] toggleFollowForUser:user success:^{
    // Do nothing
  } failure:^(NSError *error) {
    // The request failed, change the button back and show an error.
    cellView.followButton.selected = !cellView.followButton.selected;
    user.isFollowed = cellView.followButton.selected;
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                message:error.description
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                      otherButtonTitles:nil] show];
  }];
  user.isFollowed = cellView.followButton.selected;
}

- (void)cell:(WBFriendCell *)cellView didTapUserButtonAtIndex:(NSNumber *)userIndex {
  WBUser *user = ((WBUser *)self.users[userIndex.intValue]);
  // Push a user detail view controller
}

#pragma mark - Follow All/Unfollow All
- (void)followAll {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFollowed == NO"];
  NSArray *unfollowedUsers = [self.users filteredArrayUsingPredicate:predicate];
  [[WBDataSource sharedInstance] followUsers:unfollowedUsers
                                     success:^{
                                       [self getSuggestedUsers];
                                       [self.tableView reloadData];
                                     }
                                     failure:^(NSError *error) {
                                       [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                   message:error.description
                                                                  delegate:nil
                                                         cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                         otherButtonTitles:nil] show];
                                     }];
}

- (void)unfollowAll {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFollowed == YES"];
  NSArray *followedUsers = [self.users filteredArrayUsingPredicate:predicate];
  [[WBDataSource sharedInstance] unFollowUsers:followedUsers
                                       success:^{
                                         [self getSuggestedUsers];
                                         [self.tableView reloadData];
                                       }
                                       failure:^(NSError *error) {
                                         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                     message:error.description
                                                                    delegate:nil
                                                           cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                           otherButtonTitles:nil] show];
                                       }];
}

@end
