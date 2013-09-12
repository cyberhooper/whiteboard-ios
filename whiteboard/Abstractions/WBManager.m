//
//  WBManager.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/11/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBManager.h"
#import "WBDataSource.h"

@implementation WBManager

+ (void)setUpWithLauchOptions:(NSDictionary *)launchOptions {
  Class dataSourceClass = [self dataSourceSubclass];
  if (!dataSourceClass)
    [NSException raise:@"You should implement a WBDataSource subclass and put its name in the Info.plist under 'DataSourceImplementation' key." format:nil];
  [WBDataSource setDataSourceSubclass:[self dataSourceSubclass]];
  [[WBDataSource sharedInstance] setUpWithLauchOptions:launchOptions];
}

+ (Class)dataSourceSubclass {
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *dataSourceImplementation = [mainBundle infoDictionary][@"DataSourceImplementation"];
  return NSClassFromString(dataSourceImplementation);
}

@end
