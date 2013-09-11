//
//  UserFactory.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBUserFactory.h"

@implementation WBUserFactory

static Class UserClass = nil;

+ (id<WBUser>)createUser {
  return [[UserClass alloc] init];
}

+ (void)setUserClass:(Class)userConcreteClass {
  UserClass = userConcreteClass;
}

@end
