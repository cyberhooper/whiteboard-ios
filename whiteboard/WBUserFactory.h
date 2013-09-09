//
//  UserFactory.h
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUser.h"

@interface WBUserFactory : NSObject

+ (id<WBUser>)createUser;
+ (void)initWithUserClass:(Class)userConcreteClass;

@end
