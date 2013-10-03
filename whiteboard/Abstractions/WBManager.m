//
//  WBManager.m
//  whiteboard
//
//  Created by sad-fueled on 9/11/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBManager.h"
#import "WBDataSource.h"
#import "WBAccountManager.h"

@implementation WBManager

+ (void)setUpWithLauchOptions:(NSDictionary *)launchOptions {
  Class dataSourceClass = [self dataSourceSubclass];
  if (!dataSourceClass)
    [NSException raise:@"You should implement a WBDataSource subclass and put its name in the Info.plist under 'DataSourceImplementation' key." format:nil];
  [WBDataSource setDataSourceSubclass:[self dataSourceSubclass]];
  [[WBDataSource sharedInstance] setUpWithLauchOptions:launchOptions];
  Class accountManagerClass = [self accountManagerSubclass];
  if (!accountManagerClass)
    [NSException raise:@"You should implement a WBAccountManager subclass and put its name in the Info.plist under 'AccountImplementation' key." format:nil];
  [WBAccountManager setAccountManagerSubclass:[self accountManagerSubclass]];
  
}

+ (Class)dataSourceSubclass {
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *dataSourceImplementation = [mainBundle infoDictionary][@"DataSourceImplementation"];
  return NSClassFromString(dataSourceImplementation);
}

+ (Class)accountManagerSubclass {
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *accountImplementation = [mainBundle infoDictionary][@"AccountImplementation"];
  return NSClassFromString(accountImplementation);
}

@end
