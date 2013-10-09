//
//  WBParseManager.m
//  WBFramework
//
//  Created by Stéphane Copin on 10/8/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBParseManager.h"
#import "WBUser.h"
#import "WBPhoto.h"
#import "WBComment.h"
#import "WBParsePushNotificationCreator.h"
#import "WBParseAccountManager.h"
#import "WBParseDataSource.h"

@implementation WBParseManager

+ (void)initParse {
  // Any classes that is dynamically loaded at runtime (Via NSClassFromString() for example)
  // has to have been used at least once, otherwise it won't exist yet.
  // This is the case for the classes below
  [[WBParseAccountManager alloc] init];
  [[WBParseDataSource alloc] init];
}

@end
