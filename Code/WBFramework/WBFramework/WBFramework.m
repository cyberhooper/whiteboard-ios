//
//  WBFramework.m
//  WBFramework
//
//  Created by Sacha Durand Saint Omer on 10/7/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBFramework.h"
#import "WBComment.h"
#import "WBDataSource.h"

#import <Parse/Parse.h>

@implementation WBFramework

- (void)thisIsMyMethod {
  NSLog(@"OH Yeah thisIsMyMethod in the library");
  
  [WBDataSource sharedInstance];
  WBComment *commment = [[WBComment alloc] init];
}

@end
