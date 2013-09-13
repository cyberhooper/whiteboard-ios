//
//  MyViewController.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "MyViewController.h"
#import "WBUser.h"
#import "WBDataSource.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  WBUser *aUser = [WBDataSource createUser];
  NSLog(@"user.firstname : %@", aUser.firstName);
  
  // Log in :
  [[WBDataSource sharedInstance] loginWithUsername:@"testUser" andPassWord:@"test" success:^(WBUser *user) {
    NSLog(@"Logged in with user :%@", user);
  } failure:^(NSError *error) {
    NSLog(@"Loggin in failed :%@",error);
  }];
}

@end
