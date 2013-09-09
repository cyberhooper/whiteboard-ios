//
//  MyViewController.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "MyViewController.h"
#import "User.h"
#import "UserFactory.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  id<User> aUser = [UserFactory createUser];
  NSLog(@"user.firstname : %@", aUser.firstName);
}

@end
