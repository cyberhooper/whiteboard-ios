//
//  WBComment+PFObject.m
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBComment+PFObject.h"
#import "WBUser+PFUser.h"

@implementation WBComment (PFObject)

- (PFObject *)PFObject {
  PFObject *comment = [PFObject objectWithClassName:@"Comment"];
  // Set up ID
  comment.objectId = self.commentID;
  // Set up author
  [comment setObject:[self.author PFUser] forKey:@"user"];
  // Set up text
  [comment setObject:self.text forKey:@"text"];
  // Set up created at date
  [comment setObject:self.createdAt forKey:@"createdAt"];
  return comment;
}

@end
