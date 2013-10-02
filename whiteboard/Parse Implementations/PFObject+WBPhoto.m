//
//  PFObject+WBPhoto.m
//  whiteboard
//
//  Created by lnf-fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "PFObject+WBPhoto.h"
#import "PFUser+WBUser.h"
#import "PFObject+WBComment.h"

@implementation PFObject (WBPhoto)

- (WBPhoto *)WBPhoto {
  WBPhoto *wbPhoto = [[WBPhoto alloc] init];
  wbPhoto.photoID = self.objectId;
  
  if (self.isDataAvailable) {
    // Set image
    PFFile *imageFile = [self objectForKey:@"imageFile"];
    wbPhoto.url = [NSURL URLWithString:[imageFile url]];
    
    // Set author
    PFUser *user = [self objectForKey:@"user"];
    wbPhoto.author = [user WBUser];
    
    // Set created at date
    wbPhoto.createdAt = self.createdAt;
    
    // Set likes
    NSMutableArray *likes = [NSMutableArray array];
    for (PFUser *pfUser in [self objectForKey:@"likes"]) {
      [likes addObject:[pfUser WBUser]];
    }
    wbPhoto.likes = [NSArray arrayWithArray:likes];
    
    // Set comments
    NSMutableArray *comments = [@[] mutableCopy];
    for (PFObject *parseComment in [self objectForKey:@"comments"]) {
      [comments addObject:[parseComment WBComment]];
    }
    wbPhoto.comments = comments;
  }
  return wbPhoto;
}

@end
