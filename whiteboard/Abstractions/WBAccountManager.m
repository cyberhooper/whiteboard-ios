//
//  WBAccountManager.m
//  whiteboard
//
//  Created by Thibault Gauche on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBAccountManager.h"

@implementation WBAccountManager

static Class AccountManagerSubclass = nil;

+ (WBAccountManager *)sharedInstance {
  static WBAccountManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[AccountManagerSubclass alloc] init];
  });
  return sharedInstance;
}

+ (void)setAccountManagerSubclass:(Class)accountManagerSubclass {
  AccountManagerSubclass = accountManagerSubclass;
}

- (BOOL)facebookReturnHandleURL:(NSURL *)url {
  [NSException raise:@"You should override in a WBAccountManager subclass" format:nil];
  return NO;
}

- (void)loginWithFacebook:(void (^)(void))success failure:(void (^)(NSError *))failure {
  [NSException raise:@"You should override in a WBAccountManager subclass" format:nil];
}

- (void)logoutWithFacebook:(void (^)(void))success failure:(void (^)(NSError *))failure {
  [NSException raise:@"You should override in a WBAccountManager subclass" format:nil];
}

- (void)initiatizeFacebook {
  [NSException raise:@"You should override in a WBAccountManager subclass" format:nil];
}

- (void)loginWithUsername:(NSString *)username
              andPassWord:(NSString *)password
                  success:(void(^)(WBUser *user))success
                  failure:(void(^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBAccountManager subclass" format:nil];
}

- (void)logoutUser:(WBUser *)user
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBAccountManager subclass" format:nil];
}


- (void)signupWithInfo:(NSDictionary *)userInfo
               success:(void (^)(WBUser *user))success
               failure:(void (^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBAccountManager subclass" format:nil];
}

- (void)deleteUserAccount:(WBUser *)user
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBAccountManager subclass" format:nil];
}

- (void)resetPasswordForUser:(WBUser *)user
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *))failure {
  [NSException raise:@"You should override in a WBAccountManager subclass" format:nil];
}

- (void)getFacebookFriends:(void (^)(NSArray *))success
                   failure:(void (^)(NSError *))failure {
  [NSException raise:@"You should override in a WBAccountManager subclass" format:nil];
}

@end
