//
//  ZUser.h
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUser.h"
#import <Parse/PFUser.h>

/**
 This is a sample concerete implementation of WBUser using Parse.
 */

@interface ParseUser : PFUser <WBUser,PFSubclassing>

@end
