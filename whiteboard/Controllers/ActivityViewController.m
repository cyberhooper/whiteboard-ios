//
//  ActivityViewController.m
//  whiteboard
//
//  Created by Thibault Gauche on 9/20/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "ActivityViewController.h"
#import "WBDataSource.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor clearColor];
  [[WBDataSource sharedInstance] recentActivities:^(NSArray *activities) {
    NSLog(@"%@", activities);
  } failure:^(NSError *error) {
    
  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [[UITableViewCell alloc]init];
}

- (UIImage *)backgroundImage {
  return [[WBTheme sharedTheme] backgroundImage];
}

@end
