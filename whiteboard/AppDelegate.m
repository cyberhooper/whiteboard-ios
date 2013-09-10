//
//  AppDelegate.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/6/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [Parse setApplicationId:@"aIriMbx6w8kAQdmJ1HI2FRJNk6ESBzWvgBABfJR6"
                clientKey:@"nmnkgLPVzHfoQTOQEK6zphicN9ccdpJVbjMbftSF"];
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  
  
  
//  // Create user.
//  PFUser *user = [PFUser user];
//  user.username = @"testUser";
//  user.password = @"test";
//  user.email = @"sacha@fueled.com";
  

//  [[WBDataSource sharedInstance] loginWithUsername:@"testUser" andPassWord:@"test" success:^(id<WBUser> user) {
//    NSLog(@"USER : %@", user);
//  } failure:^(NSError *error) {
//    NSLog(@"ERROR : %@", error);
//  }];
  
  return YES;
}

@end
