//
//  WBDataSource.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/10/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBDataSource.h"

@implementation WBDataSource

static Class DataSourceSubclass = nil;

+ (WBDataSource *)sharedInstance {
  static WBDataSource *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[DataSourceSubclass alloc] init];
  });
  return sharedInstance;
}

- (void)loginWithUsername:(NSString *)username
              andPassWord:(NSString *)password
                  success:(void(^)(id<WBUser> user))success
                  failure:(void(^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (void)logoutUser:(id<WBUser>)user
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

+ (void)setDataSourceSubclass:(Class)dataSourceSubclass {
  DataSourceSubclass = dataSourceSubclass;
}

- (void)signupWithInfo:(NSDictionary *)userInfo
               success:(void (^)(id<WBUser> user))success
               failure:(void (^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (void)deleteUserAccount:(id<WBUser>)user
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (void)resetPasswordForUser:(id<WBUser>)user
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (id<WBUser>)currentUser {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
  return nil;
}

+ (id<WBUser>)createUser {
  if (DataSourceSubclass !=[self class] ) {
    @try {
      id <WBUser> user = [DataSourceSubclass createUser];
      return user;
    }
    @catch (NSException *exception) {
      [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
    }
    @finally {
      
    }
  }
  else {
        [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
  }

}

- (void)saveUser:(id<WBUser>)user
         success:(void(^)(void))success
         failure:(void(^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (void)setUpWithLauchOptions:(NSDictionary *)launchOptions {
    [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

@end
