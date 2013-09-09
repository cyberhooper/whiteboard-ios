//
//  UserFactory.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "UserFactory.h"

@implementation UserFactory

static Class UserClass = nil;

+ (id<User>)createUser {
  return [[UserClass alloc] init];
}

+ (void)initWithUserClass:(Class)userConcreteClass {
  UserClass = userConcreteClass;
}

@end
