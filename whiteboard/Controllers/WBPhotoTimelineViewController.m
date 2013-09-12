//
//  WBPhotoTimelineViewController.m
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoTimelineViewController.h"
#import "WBPhotoTimelineSectionHeaderView.h"
#import "WBPhotoTimelineCell.h"
#import "UIImageView+SLImageLoader.h"

@interface WBPhotoTimelineViewController ()

@end

@implementation WBPhotoTimelineViewController

static NSString *cellIdentifier = @"WBPhotoTimelineCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  UINib *nib = [UINib nibWithNibName:[self tableCellNib] bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - UITableViewDataSource
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
  
  sectionHeaderView.displayName = [[self.photos objectAtIndex:section] valueForKey:@"username"];
  sectionHeaderView.date = [NSDate date];
  [sectionHeaderView.profilePictureImageView setImageWithPath:[[self.photos objectAtIndex:section] valueForKey:@"photoUrl"]
                                                  placeholder:nil];
  sectionHeaderView.numberOfLikes = @2;
  sectionHeaderView.numberOfComments = @3;
  
  return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//warning MAGIC NUMBER. REPLACE ME
  return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.photos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  WBPhotoTimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  [self configureCell:cell forRowAtIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(WBPhotoTimelineCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  // Set the cell image
  [cell.photoImageView setImageWithPath:[[self.photos objectAtIndex:indexPath.section] valueForKey:@"photoUrl"] placeholder:nil];
}

#pragma mark - TableCellNib
- (NSString *)tableCellNib {
  return NSStringFromClass([WBPhotoTimelineCell class]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
