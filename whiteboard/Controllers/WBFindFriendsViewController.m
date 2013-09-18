//
//  WBFindFriendsViewController.m
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBFindFriendsViewController.h"
#import "WBDataSource.h"
#import "UIImageView+SLImageLoader.h"

@interface WBFindFriendsViewController ()

@end

@implementation WBFindFriendsViewController

static const int kInviteFriendsSectionIndex = 0;
static const int kFriendsListSectionIndex = 1;

static NSString *cellIdentifier = @"WBFriendCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setUpView];
  [self getSuggestedUsers];
}

#pragma mark - Config
- (void)setUpView {
  // Setup NIB
  UINib *nib = [UINib nibWithNibName:[self tableCellNib] bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
}

- (NSString *)tableCellNib {
  return NSStringFromClass([WBFriendCell class]);
}

- (void)dummyData {
  self.users = @[@"Thibault", @"Sacha", @"Petter", @"German"];
}

- (void)getSuggestedUsers {
  [[WBDataSource sharedInstance] suggestedUsers:^(NSArray *users) {
    self.users = users;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
  if (section == kInviteFriendsSectionIndex) {
    return 1;
  }
  return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  WBFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
  [self configureCell:cell forRowAtIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(WBFriendCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == kInviteFriendsSectionIndex) {
    cell.textLabel.text = @"Invite Friends";
  } else {
    cell.delegate = self;
    WBUser *user = ((WBUser *)self.users[indexPath.row]);
    cell.name = user.displayName;
    [cell.avatarImageView setImageWithPath:user.avatar.absoluteString placeholder:nil];
    cell.followButton.selected = user.isFollowed;
    cell.userIndex = @(indexPath.row);
  }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == kInviteFriendsSectionIndex) {
    return 44.0f;
  }
  return [WBFriendCell heightForCell];
}

#pragma mark - WBFriendCellDelegate
- (void)cell:(WBFriendCell *)cellView didTapFollowButtonAtIndex:(NSNumber *)userIndex {
  WBUser *user = ((WBUser *)self.users[userIndex.intValue]);
  [[WBDataSource sharedInstance] toggleFollowForUser:user success:^{
    [self getSuggestedUsers];
    [self.tableView reloadData];
  } failure:^(NSError *error) {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                message:error.description
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                      otherButtonTitles:nil] show];
  }];
}

- (void)cell:(WBFriendCell *)cellView didTapUserButtonAtIndex:(NSNumber *)userIndex {
  WBUser *user = ((WBUser *)self.users[userIndex.intValue]);
  // Push a user detail view controller
}

@end
