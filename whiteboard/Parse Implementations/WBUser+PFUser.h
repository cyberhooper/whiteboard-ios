//
//  WBUser+PFUser.h
//  whiteboard
//
//  Created by ttg-fueled on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBUser.h"
#import <Parse/Parse.h>

@interface WBUser (PFUser)

- (PFUser *)PFUser;

@end
