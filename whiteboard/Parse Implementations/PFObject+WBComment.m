//
//  PFObject+WBComment.m
//  whiteboard
//
//  Created by lnf-fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "PFObject+WBComment.h"
#import "PFUser+WBUser.h"

@implementation PFObject (WBComment)

- (WBComment *)WBComment {
  [self fetchIfNeeded];
  WBComment *comment = [[WBComment alloc] init];
  // Set ID
  comment.commentID = self.objectId;
  [self fetchIfNeeded];
  if ([self isDataAvailable]) {
    // Set author
    comment.author = [[self objectForKey:@"user"] WBUser];
    // Set text
    comment.text = [self objectForKey:@"text"];
    // Set created at date
    comment.createdAt = self.createdAt;
  }
  return comment;
}

@end
