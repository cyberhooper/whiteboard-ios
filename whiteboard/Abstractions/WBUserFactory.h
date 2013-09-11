//
//  UserFactory.h
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUser.h"

/**
 WBUserFactory is an Abstract Factory that creates WBUser objects. 
 The developer must call setUserClass: to set the concrete class that the factory returns.
 Calling createUser will return a single instance of the specified concrete WBUser class.
 */
@interface WBUserFactory : NSObject

/**
 Factory method that returns a concrete implementation of WBUser.
 The developer must supply the concrete class.
 @returns A concrete object that implements WBUser
 */
+ (id<WBUser>)createUser;

/**
 Set the concrete class that the factory returns. The developer supplies the class and it must implement WBUser.
 @param userConcreteClass The concrete WBUser class that the factory should return.
 */
+ (void)setUserClass:(Class)userConcreteClass;

@end
