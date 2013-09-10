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
                                    if (user) {                                      
                                      id<WBUser> wbUser = [WBUserFactory createUser];
                                      wbUser.userName = user.username;
                                      success(wbUser);
                                    } else {
                                      // The login failed. Check error to see why.
                                      failure (error);
                                    }
                                  }];
}


- (void)signupWithInfo:(NSDictionary *)userInfos
               success:(void (^)(id<WBUser>))success
               failure:(void (^)(NSError *))failure {
  PFUser *currentUser = [PFUser user];
  [currentUser setUsername:[userInfos objectForKey:@"userName"]];
  [currentUser setPassword:[userInfos objectForKey:@"password"]];
  [currentUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      id<WBUser> wbUser = [WBUserFactory createUser];
      wbUser.userName = [currentUser username];
      success(wbUser);
    }
    else {
      failure (error);
    }
  }];
  
}

-(void)deleteUserAccount:(id<WBUser>)user
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
@end
