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

- (id<WBUser>)currentUser {
  if (![PFUser currentUser]) {
    return nil;
  }
  
  PFUser *parseUser = [PFUser currentUser];
  id<WBUser> currentUser = [WBUserFactory createUser];
  currentUser.userName = parseUser.username;
  return currentUser;
}

@end
