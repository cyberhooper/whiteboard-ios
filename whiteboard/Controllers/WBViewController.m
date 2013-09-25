//
//  WBViewController.m
//  whiteboard
//
//  Created by prs-fueled on 9/12/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBViewController.h"

@implementation WBViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Set defaults
  self.view.backgroundColor = [UIColor colorWithPatternImage:[self backgroundImage]];
}

#pragma mark - Default
- (UIImage *)backgroundImage {
  [NSException raise:@"You should override in a WBViewController subclass" format:nil];
  return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
