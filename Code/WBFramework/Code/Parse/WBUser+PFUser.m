//
//  WBUser+PFUser.m
//  whiteboard
//
//  Created by ttg-fueled on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBUser+PFUser.h"

@implementation WBUser (PFUser)

- (PFUser *)PFUser {
  PFUser *pfUser = [PFUser user];
  
  pfUser.objectId = self.userID;
  [pfUser setObject:self.displayName forKey:@"displayName"];
  pfUser.username = self.username;
  [pfUser setObject:self.firstName forKey:@"firstname"];
  [pfUser setObject:self.lastName forKey:@"lastName"];
  pfUser.email = self.email;
  PFFile *avatar = [PFFile fileWithData:[NSData dataWithContentsOfURL:self.avatar]];
  [pfUser setObject:avatar forKey:@"avatar"];
  [pfUser setObject:self.numberOfFollowers forKey:@"numberOfFollowers"];
  [pfUser setObject:self.numberFollowing forKey:@"numberFollowing"];
  
  return pfUser;
}

@end
