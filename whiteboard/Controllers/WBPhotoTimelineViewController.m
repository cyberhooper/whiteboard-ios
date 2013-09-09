//
//  WBPhotoTimelineViewController.m
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoTimelineViewController.h"
#import "WBPhotoTimelineSectionHeaderView.h"

@interface WBPhotoTimelineViewController ()

@end

@implementation WBPhotoTimelineViewController

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
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  WBPhotoTimelineSectionHeaderView *sectionHeaderView = nil;
  NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WBPhotoTimelineSectionHeaderView class])
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
  sectionHeaderView.profilePictureImage = nil;
  
  return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 44.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.photos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  }
  
  [self configureCell:cell forRowAtIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
