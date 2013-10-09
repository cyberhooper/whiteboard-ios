//
//  PFObject+WBActivity.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/25/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "PFObject+WBActivity.h"
#import "WBParseConstants.h"
#import "PFUser+WBUser.h"
#import "PFObject+WBPhoto.h"

@implementation PFObject (WBActivity)

- (WBActivity *)WBActivity {
  WBActivity *activity = [[WBActivity alloc] init];
  activity.type = [self objectForKey:kActivityTypeKey];
  PFUser *fromUser = [self objectForKey:kActivityFromUserKey];
  activity.fromUser = [fromUser WBUser];
  activity.createdAt = self.createdAt;
  
  if ([activity.type isEqualToString:kActivityTypeLike] || [activity.type isEqualToString:kActivityTypeComment]) {
    PFObject *photo = [self objectForKey:@"photo"];
    activity.photo = [photo WBPhoto];
  }
  return activity;
}

@end
