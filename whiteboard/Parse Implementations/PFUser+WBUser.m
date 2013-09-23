//
//  PFUser+WBUser.m
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "PFUser+WBUser.h"

@implementation PFUser (WBUser)

- (WBUser *)WBUser{
  WBUser *wbUser = [[WBUser alloc]init];
  wbUser.userID = self.objectId;
  wbUser.displayName = [self objectForKey:@"displayName"];
  wbUser.username = self.username;
  wbUser.firstName = [self objectForKey:@"firstname"];
  wbUser.lastName = [self objectForKey:@"lastname"];
  wbUser.email = [self email];
  PFFile *avatar = [self objectForKey:@"avatar"];
  wbUser.avatar = [NSURL URLWithString:[avatar url]];
  wbUser.createdAt = self.createdAt;
  wbUser.updatedAt = self.updatedAt;
  wbUser.numberOfFollowers = [self objectForKey:@"numberOfFollowers"];
  wbUser.numberFollowing = [self objectForKey:@"numberFollowing"];
  return wbUser;
}

@end
