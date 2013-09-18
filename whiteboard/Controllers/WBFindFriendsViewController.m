//
//  WBFindFriendsViewController.m
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBFindFriendsViewController.h"
#import "WBPhotoTimelineCell.h"

@interface WBFindFriendsViewController ()

@end

@implementation WBFindFriendsViewController

static const int kInviteFriendsSectionIndex = 0;
static const int kFriendsListSectionIndex = 1;

static NSString *cellIdentifier = @"WBPhotoTimelineCell";

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  [self setUpView];
}

#pragma mark - Config
- (void)setUpView {
  // Setup NIB
  UINib *nib = [UINib nibWithNibName:[self tableCellNib] bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
}

- (NSString *)tableCellNib {
  return NSStringFromClass([WBPhotoTimelineCell class]);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


@end
