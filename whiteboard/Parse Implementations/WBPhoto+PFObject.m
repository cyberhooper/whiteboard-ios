//
//  WBPhoto+PFObject.m
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhoto+PFObject.h"
#import "WBUser+PFUser.h"
#import "WBComment+PFObject.h"

@implementation WBPhoto (PFObject)

- (PFObject *)PFObject {
  // Create new PFObject
  PFObject *photo = [PFObject objectWithClassName:@"Photo"];
  // Set ID
  photo.objectId = self.photoID;
  // Set image
  PFFile *photoFile = [PFFile fileWithData:UIImagePNGRepresentation(self.image)];
  [photo setObject:photoFile forKey:@"imageFile"];
  // Set author
  [photo setObject:[self.author PFUser] forKey:@"user"];
  // Set created at date
  [photo setObject:self.createdAt forKey:@"createdAt"];
  
  // Set likes
  NSMutableArray *likes = [NSMutableArray arrayWithCapacity:self.likes.count];
  for (WBUser *wbUser in self.likes) {
    [likes addObject:[wbUser PFUser]];
  }
  [photo setObject:[NSArray arrayWithArray:likes] forKey:@"likes"];
  // Set comments
  NSMutableArray *comments = [NSMutableArray arrayWithCapacity:self.comments.count];
  for (WBComment *wbComment in self.likes) {
    [comments addObject:[wbComment PFObject]];
  }
  [photo setObject:[NSArray arrayWithArray:comments] forKey:@"comments"];
  
  return photo;
}

@end
