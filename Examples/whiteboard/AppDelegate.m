//
//  AppDelegate.m
//  whiteboard
//
//  Created by sad-fueled on 9/6/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "AppDelegate.h"
#import "Whiteboard.h"
#import "WBTheme.h"
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
  //add
  [DDLog addLogger:[DDASLLogger sharedInstance]];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
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

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [[WBDataSource sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  DDLogError(@"Failed to register for push notification : %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  UIApplicationState state = [application applicationState];
  if (state != UIApplicationStateActive) {
    [self hanldePushWithOptions:userInfo];
  }
}

- (void)hanldePushWithOptions:(NSDictionary *)userInfo {
  if ([[WBDataSource sharedInstance] currentUser]) {
    NSString *type = userInfo[@"type"];
    NSString *photoId = userInfo[@"photoId"];
    NSString *userId = userInfo[@"fromUser"];
    
    WBTabBarController *tabBarVC = (WBTabBarController*) self.window.rootViewController;
    WBNavigationController *navVC = (WBNavigationController*) tabBarVC.homeNavigationController;
    [tabBarVC setSelectedViewController:navVC];
    
    if ([type isEqualToString:@"like"] || [type isEqualToString:@"comment"]) {
      [navVC pushViewController:[self photoDetailVCWithPhotoId:photoId] animated:YES];
    }
    else if ([type isEqualToString:@"follow"]) {
      [navVC pushViewController:[self profileVCWithUserId:userId] animated:YES];
    }
  }
}

- (WBPhotoDetailsViewController *)photoDetailVCWithPhotoId:(NSString *)photoId {
  WBPhotoDetailsViewController *vc = [[WBPhotoDetailsViewController alloc] init];
  WBPhoto *photo = [[WBPhoto alloc] init];
  photo.photoID = photoId;
  vc.photo = photo;
  return vc;
}

- (ProfileViewController *)profileVCWithUserId:(NSString *)userId {
  ProfileViewController *vc = [[ProfileViewController alloc] init];
  WBUser *user = [[WBUser alloc] init];
  user.userID = userId;
  vc.user = user;
  return vc;
}

@end
