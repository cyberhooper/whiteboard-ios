//
//  ParseDataSource.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/10/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "ParseDataSource.h"
#import <Parse/Parse.h>
#import "WBUserFactory.h"

#import "ParseUser.h"

@implementation ParseDataSource

- (void)loginWithUsername:(NSString *)username andPassWord:(NSString *)password success:(void (^)(id<WBUser>))success failure:(void (^)(NSError *))failure {
  [PFUser logInWithUsernameInBackground:username password:password
                                  block:^(PFUser *user, NSError *error) {
                                    if (user)
                                      success([self currentUser]);
                                    else
                                      failure (error);
                                  }];
}

- (void)logoutUser:(id<WBUser>)user
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure {
  // Parse logout is instant since it deletes the current pfuser on disk.
  [PFUser logOut];
  success();
}

- (void)signupWithInfo:(NSDictionary *)userInfo
               success:(void (^)(id<WBUser>))success
               failure:(void (^)(NSError *))failure {
  PFUser *currentUser = [PFUser user];
  [currentUser setUsername:[userInfo objectForKey:@"userName"]];
  [currentUser setPassword:[userInfo objectForKey:@"password"]];
  [currentUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      id<WBUser> wbUser = [WBUserFactory createUser];
      wbUser.username = [currentUser username];
      success(wbUser);
    }
    else {
      failure (error);
    }
  }];
}
   
- (id<WBUser>)currentUser {
  return [ParseUser currentUser];
}

- (void)deleteUserAccount:(id<WBUser>)user
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure {
  [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      success();
    }
    else {
      failure (error);
    }
  }];
}

- (void)saveUser:(id<WBUser>)user
         success:(void(^)(void))success
         failure:(void(^)(NSError *error))failure {
  PFUser *pfUser = (PFUser*)user;
  [pfUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded && success)
      success();
    else if (failure)
      failure(error);
  }];
}
                 
@end
