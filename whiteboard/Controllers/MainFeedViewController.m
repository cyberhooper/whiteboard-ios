//
//  MainFeedViewController.m
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "MainFeedViewController.h"
#import "MainFeedCell.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  // Add dummy data
  NSMutableArray *array = [NSMutableArray array];
  for(NSInteger i = 1; i < 8; i++){
    NSString *image = [NSString stringWithFormat:@"http://static.ddmcdn.com/gif/smart-car-%i.jpg", i];
    NSString *username = [NSString stringWithFormat:@"Test %i", i];
    
    NSDictionary *dict = @{@"photoUrl": image, @"username": username};
    [array addObject:dict];
  }
  
  self.photos = array;
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 296.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//warning MAGIC NUMBER. REPLACE ME
  return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterrInSection:(NSInteger)section {
//warning MAGIC NUMBER. REPLACE ME
  return 30.0f;
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
