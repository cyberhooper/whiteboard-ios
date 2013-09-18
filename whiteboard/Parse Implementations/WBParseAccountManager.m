//
//  WBParseAccountManager.m
//  whiteboard
//
//  Created by Thibault Gauche on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBParseAccountManager.h"
#import <Parse/Parse.h>
#import "WBParseDataSource.h"
#import "WBUser+ParseUser.h"

@implementation WBParseAccountManager


- (void)loginWithUsername:(NSString *)username
              andPassWord:(NSString *)password
                  success:(void (^)(WBUser *))success
                  failure:(void (^)(NSError *))failure {
  
  [PFUser logInWithUsernameInBackground:username
                               password:password
                                  block:^(PFUser *user, NSError *error) {
                                    if (user) {
                                      [WBUser mapWBUser:user];
                                      success([[WBDataSource sharedInstance] currentUser]);
                                    }
                                    else {
                                      failure (error);
                                    }
                                  }];
}

- (void)logoutUser:(WBUser *)user
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure {
  // Parse logout is instant since it deletes the current pfuser on disk.
  [WBDataSource sharedInstance].currentUser = nil;
  [PFUser logOut];
  success();
}

- (void)signupWithInfo:(NSDictionary *)userInfo
               success:(void (^)(WBUser *))success
               failure:(void (^)(NSError *))failure {
  PFUser *pfCurrentUser = [PFUser user];
  [pfCurrentUser setUsername:[userInfo objectForKey:@"userName"]];
  [pfCurrentUser setPassword:[userInfo objectForKey:@"password"]];
  [pfCurrentUser setEmail:[userInfo objectForKey:@"email"]];
  
  [pfCurrentUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      [WBUser mapWBUser:pfCurrentUser];
      [self loginWithUsername:pfCurrentUser.username andPassWord:pfCurrentUser.password
                      success:^(WBUser *user) {
                        success([WBDataSource sharedInstance].currentUser);
                      } failure:^(NSError *error) {
                        failure (error);
                      }];
    }
    else {
      failure (error);
    }
  }];
}

- (void)deleteUserAccount:(WBUser *)user
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure {
  PFUser *pfUser = [WBUser mapPFUser:user];
  [pfUser deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (success && succeeded) {
      [WBDataSource sharedInstance].currentUser = nil;
      success();
    } else if (failure)
      failure (error);
  }];
}

- (void)resetPasswordForUser:(WBUser *)user
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *))failure {
  [PFUser requestPasswordResetForEmailInBackground:[user email] block:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      success();
    }
    else {
      failure (error);
    }
  }];
}

- (void)initiatizeFacebook {
  [PFFacebookUtils initializeFacebook];
}

- (BOOL)facebookReturnHandleURL:(NSURL *)url {
  return [PFFacebookUtils handleOpenURL:url];
}

- (void)loginWithFacebook:(void(^)(void))success
                  failure:(void(^)(NSError *error))failure {
  NSArray *permissionsArray = @[@"basic_info", @"email"];
  
  // Login PFUser using Facebook
  [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
    if (!user) {
      failure(error);
    }
    else {
      success();
    }
  }];
}

- (void)logoutWithFacebook:(void(^)(void))success
                   failure:(void(^)(NSError *error))failure {
  [self logoutUser:nil success:^{
    success();
  } failure:^(NSError *error) {
    failure(error);
  }];
}
@end
