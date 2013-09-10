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
  return YES;
}

@end
