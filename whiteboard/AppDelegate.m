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
  [ParseUser registerSubclass];
  [Parse setApplicationId:@"aIriMbx6w8kAQdmJ1HI2FRJNk6ESBzWvgBABfJR6"
                clientKey:@"nmnkgLPVzHfoQTOQEK6zphicN9ccdpJVbjMbftSF"];
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  [WBManager setUp];
  return YES;
}

@end
