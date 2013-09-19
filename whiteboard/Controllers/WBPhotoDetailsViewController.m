//
//  WBPhotoDetailsViewController.m
//  whiteboard
//
//  Created by prs-fueled on 9/19/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsViewController.h"
#import "WBPhotoTimelineSectionHeaderView.h"
#import "UIImageView+WBImageLoader.h"

@interface WBPhotoDetailsViewController () <UITableViewDataSource, UITableViewDelegate, WBPhotoTimelineSectionHeaderViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

typedef enum {
  DetailsCellTypePhoto = 0,
  DetailsCellTypeLikers,
  DetailsCellTypeComments,
  DetailsCellTypeAddComment
}DetailsCellType;

@implementation WBPhotoDetailsViewController

static NSString *PhotoCellIdentifier = @"PhotoCellIdentifier";

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupView];
}

#pragma mark - Setup
- (void)setupView {
  //
}

#pragma mark - UITableView
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
  
  sectionHeaderView.displayName = self.photo.author.displayName;
  sectionHeaderView.date = self.photo.createdAt;
  [sectionHeaderView.profilePictureImageView setImageWithPath:self.photo.author.avatar.absoluteString
                                                  placeholder:nil];
  sectionHeaderView.delegate = self;
  
  return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  //warning MAGIC NUMBER. REPLACE ME
  return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case DetailsCellTypePhoto: {
      // Warning change this
      return 296.f;
      break;
    }
      
    default:
      break;
  }
  
  return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  }
  
  return cell;
}

#pragma mark - Getters
- (UITableView *)tableView {
  if(_tableView != nil){
    return _tableView;
  }
  
  CGRect frame = CGRectMake(0.f,
                            0.f,
                            self.view.frame.size.width,
                            self.view.frame.size.height);
  UITableView *table = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
  table.backgroundColor = [UIColor clearColor];
  table.separatorStyle = UITableViewCellSeparatorStyleNone;
  table.delegate = self;
  table.dataSource = self;
  
  _tableView = table;
  return _tableView;
}

#pragma mark - Layout

#pragma mark - Config
- (UIImage *)backgroundImage {
  return [[WBTheme sharedTheme] backgroundImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
