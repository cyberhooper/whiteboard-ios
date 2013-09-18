//
//  WBUser+ParseUser.h
//  whiteboard
//
//  Created by Thibault Gauche on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBUser.h"
#import <Parse/Parse.h>

@interface WBUser (ParseUser)
+ (WBUser *)mapWBUser:(PFUser *)user;
+ (PFUser *)mapPFUser:(WBUser *)user;
@end
