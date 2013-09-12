//
//  AppDelegate.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/6/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "ParseUser.h"
#import "WBManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [WBManager setUpWithLauchOptions:launchOptions];
  return YES;
}

@end
