//
//  WBUser.m
//  whiteboard
//
//  Created by Thibault Gauche on 9/13/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBUser.h"

@implementation WBUser

- (NSString *)description {
  NSMutableString *description = [@"" mutableCopy];
  
  NSString *isFollowedString = _isFollowed ? @"Followed" : @" Not Followed";
  [description appendString:isFollowedString];
  return description;
}

@end
