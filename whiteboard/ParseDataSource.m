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



@end
