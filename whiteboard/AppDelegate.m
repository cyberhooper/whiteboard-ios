//
//  AppDelegate.m
//  whiteboard
//
//  Created by sad-fueled on 9/6/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "AppDelegate.h"
//#import <Parse/Parse.h>
#import "WBManager.h"
#import "WBTheme.h"
#import "WBAccountManager.h"
#import "WBPhotoDetailsViewController.h"
#import "ProfileViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [[WBAccountManager sharedInstance]initiatizeFacebook];
  
  [application registerForRemoteNotificationTypes:  UIRemoteNotificationTypeAlert |
                                                    UIRemoteNotificationTypeBadge |
                                                    UIRemoteNotificationTypeSound];
  
  // Extract the notification payload dictionary
  NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (remoteNotificationPayload)
    [self hanldePushWithOptions:remoteNotificationPayload];
  return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [WBManager setUpWithLauchOptions:launchOptions];
  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [[WBAccountManager sharedInstance]facebookReturnHandleURL:url];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
  
  [PFPush storeDeviceToken:deviceToken];
  
  if (application.applicationIconBadgeNumber != 0) {
    application.applicationIconBadgeNumber = 0;
  }
  
  [[PFInstallation currentInstallation] addUniqueObject:@"" forKey:@"channels"];
  
  if ([PFUser currentUser]) {
    // Make sure they are subscribed to their private push channel
    NSString *privateChannelName = [[PFUser currentUser] objectForKey:@"channel"];
    if (privateChannelName && privateChannelName.length > 0) {
      NSLog(@"Subscribing user to %@", privateChannelName);
      [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:@"channels"];
    }
  }
  // Save the added channel(s)
  [[PFInstallation currentInstallation] saveEventually];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"Failed to register for push notification : %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  UIApplicationState state = [application applicationState];
  if (state != UIApplicationStateActive) {
    [self hanldePushWithOptions:userInfo];
  }
}

- (void)hanldePushWithOptions:(NSDictionary *)userInfo {
  if ([PFUser currentUser]) {
    NSString *type = userInfo[@"type"];
    NSString *photoId = userInfo[@"photoId"];
    NSString *userId = userInfo[@"fromUser"];
    
    if ([type isEqualToString:@"like"] || [type isEqualToString:@"comment"]) {
      WBTabBarController *tabBarVC = (WBTabBarController*) self.window.rootViewController;
      WBNavigationController *navVC = (WBNavigationController*) tabBarVC.homeNavigationController;
      [tabBarVC setSelectedViewController:navVC];
      WBPhotoDetailsViewController *photoDetailVC = [[WBPhotoDetailsViewController alloc] init];
      WBPhoto *photo = [[WBPhoto alloc] init];
      photo.photoID = photoId;
      photoDetailVC.photo = photo;
      [navVC pushViewController:photoDetailVC animated:YES];
    }
    else if ([type isEqualToString:@"follow"]) {
      WBTabBarController *tabBarVC = (WBTabBarController*) self.window.rootViewController;
      WBNavigationController *navVC = (WBNavigationController*) tabBarVC.homeNavigationController;
      [tabBarVC setSelectedViewController:navVC];
      ProfileViewController *profileVC = [[ProfileViewController alloc] init];
      WBUser *user = [[WBUser alloc] init];
      user.userID = userId;
      profileVC.user = user;
      [navVC pushViewController:profileVC animated:YES];
    }
  }
}

@end
