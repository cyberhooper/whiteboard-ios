//
//  WBComment+PFObject.h
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBComment.h"
#import <Parse/Parse.h>

@interface WBComment (PFObject)

- (PFObject *)PFObject;

@end
