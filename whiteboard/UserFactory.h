//
//  UserFactory.h
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserFactory : NSObject

+ (id<User>)createUser;
+ (void)initWithUserClass:(Class)userConcreteClass;

@end
