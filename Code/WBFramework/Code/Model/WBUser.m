//
//  WBUser.m
//  whiteboard
//
//  Created by ttg-fueled on 9/13/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBUser.h"

@implementation WBUser

- (BOOL)isEqual:(id)object {
  return [[(WBUser *)object userID] isEqualToString:self.userID];
}

@end
