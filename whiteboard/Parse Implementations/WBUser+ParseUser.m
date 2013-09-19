//
//  WBUser+ParseUser.m
//  whiteboard
//
//  Created by Thibault Gauche on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBUser+ParseUser.h"

@implementation WBUser (ParseUser)

+ (WBUser *)mapWBUser:(PFUser *)user {
  WBUser *wbUser = [[WBUser alloc]init];
  wbUser.userID = user.objectId;
  wbUser.displayName = [user objectForKey:@"displayName"];
  wbUser.username = user.username;
  wbUser.firstName = [user objectForKey:@"firstname"];
  wbUser.lastName = [user objectForKey:@"lastname"];
  wbUser.email = [user email];
  wbUser.avatar = [user objectForKey:@"avatar"];
  wbUser.createdAt = user.createdAt;
  wbUser.updatedAt = user.updatedAt;
  wbUser.numberOfFollowers = [user objectForKey:@"numberOfFollowers"];
  wbUser.numberFollowing = [user objectForKey:@"numberFollowing"];
  return wbUser;
}

+ (PFUser *)mapPFUser:(WBUser *)user {
  PFUser *pfUser = [PFUser user];
  
  pfUser.objectId = user.userID;
  [pfUser setObject:user.displayName forKey:@"displayName"];
  pfUser.username = user.username;
  [pfUser setObject:user.firstName forKey:@"firstname"];
  [pfUser setObject:user.lastName forKey:@"lastName"];
  pfUser.email = user.email;
  [pfUser setObject:user.avatar forKey:@"avatar"];
  [pfUser setObject:user.numberOfFollowers forKey:@"numberOfFollowers"];
  [pfUser setObject:user.numberFollowing forKey:@"numberFollowing"];
  
  return pfUser;
}

@end
