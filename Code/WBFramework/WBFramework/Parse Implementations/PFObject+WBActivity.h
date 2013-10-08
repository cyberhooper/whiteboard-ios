//
//  PFObject+WBActivity.h
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/25/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Parse/Parse.h>
#import "WBActivity.h"

@interface PFObject (WBActivity)

- (WBActivity *)WBActivity;

@end
