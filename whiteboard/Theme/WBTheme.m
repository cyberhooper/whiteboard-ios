//
//  WBTheme.m
//  whiteboard
//
//  Created by lnf-fueled on 9/12/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBTheme.h"

@interface WBTheme()

@property (nonatomic, strong) NSDictionary *themeDict;

@end

@implementation WBTheme

+ (WBTheme *)sharedTheme {
  static WBTheme *sharedTheme = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedTheme = [[self alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WBTheme" ofType:@"plist"];
    sharedTheme.themeDict = [NSDictionary dictionaryWithContentsOfFile:path];
  });
  return sharedTheme;
}

- (NSString *)headerImageName {
  return [self.themeDict objectForKey:@"headerImageName"];
}

@end