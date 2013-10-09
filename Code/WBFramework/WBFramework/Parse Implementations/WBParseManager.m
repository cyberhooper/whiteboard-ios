//
//  WBParseManager.m
//  WBFramework
//
//  Created by Stéphane Copin on 10/8/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBParseManager.h"
#import <Parse/Parse.h>
#import "WBUser+PFUser.h"
#import "WBPhoto+PFObject.h"
#import "WBComment+PFObject.h"
#import "WBParseConstants.h"
#import "WBParsePushNotificationCreator.h"
#import "WBParseAccountManager.h"
#import "WBParseDataSource.h"

@implementation WBParseManager

+ (void)initParse {
  [[FBRequest alloc] init];
  [[WBPhoto alloc] init];
  [[WBComment alloc] init];
  [[WBParsePushNotificationCreator alloc] init];
  [[WBParseAccountManager alloc] init];
  [[WBParseDataSource alloc] init];
}

@end
