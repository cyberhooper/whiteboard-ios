
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
  WBComment *comment = [[WBComment alloc] init];
  comment.commentID = self.objectId;

  if (self.isDataAvailable) {
    comment.author = [[self objectForKey:@"user"] WBUser];
    comment.text = [self objectForKey:@"text"];
    comment.createdAt = self.createdAt;
  }
  return comment;
}

@end
