//
//  WBAccountManager.h
//  whiteboard
//
//  Created by Thibault Gauche on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUser.h"

static NSString *kFacebookFriendsKey = @"kFacebookFriends";

@interface WBAccountManager : NSObject

+ (WBAccountManager *)sharedInstance;


+ (void)setAccountManagerSubclass:(Class)accountManagerSubclass;

/**
 Log in with the given username and password.
 On success give back the newly logged in WBUser in a block, otherwise give the error back in a block.
 @param username The supplied username
 @param password The supplied password
 @param success The success block, called with the new WBUser
 @param failure The failure block, called with an NSError
 */
- (void)loginWithUsername:(NSString *)username
              andPassWord:(NSString *)password
                  success:(void(^)(WBUser *user))success
                  failure:(void(^)(NSError *error))failure;


/**
 Logout the given user. On failure to log out, return the NSError in the failure block.
 @param user The user to log out
 @param success The success block
 @param failure The failure block, called with an NSError
 */
- (void)logoutUser:(WBUser *)user
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure;


/**
 Sign up for a Whiteboard account with the given dictionary of user info (name, email, etc.).
 On success give back the newly logged in WBUser in a block, otherwise give the error back in a block.
 @param userInfo The user info to use when creating an account.
 @param success The success block, called with the new WBUser
 @param failure The failure block, called with an NSError
 */
- (void)signupWithInfo:(NSDictionary *)userInfo
               success:(void(^)(WBUser *user))success
               failure:(void(^)(NSError *error))failure;


/**
 Delete the given WBUser from the server.
 On failure to delete, give the error back in a block.
 @param user The WBUser to delete
 @param success The success block
 @param failure The failure block, called with an NSError
 */
- (void)deleteUserAccount:(WBUser *)user
                  success:(void(^)(void))success
                  failure:(void(^)(NSError *error))failure;

/**
 reset password of the given WBUser from the server.
 On failure to reset, give the error back in a block.
 @param user The WBUser to reset password
 @param success The success block
 @param failure The failure block, called with an NSError
 */
- (void)resetPasswordForUser:(WBUser *)user
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *))failure;


- (void)initiatizeFacebook;

- (BOOL)facebookReturnHandleURL:(NSURL *)url;

- (void)loginWithFacebook:(void(^)(void))success
                  failure:(void(^)(NSError *error))failure;

- (void)logoutWithFacebook:(void(^)(void))success
                   failure:(void(^)(NSError *error))failure;

- (void)getFacebookFriends:(void(^)(NSArray *friends))success
                   failure:(void(^)(NSError *error))failure;

@end
