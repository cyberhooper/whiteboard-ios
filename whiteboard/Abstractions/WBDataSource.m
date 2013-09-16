
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
                  success:(void(^)(WBUser *user))success
                  failure:(void(^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (void)logoutUser:(WBUser *)user
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

+ (void)setDataSourceSubclass:(Class)dataSourceSubclass {
  DataSourceSubclass = dataSourceSubclass;
}

- (void)signupWithInfo:(NSDictionary *)userInfo
               success:(void (^)(WBUser *user))success
               failure:(void (^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (void)deleteUserAccount:(WBUser *)user
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (void)resetPasswordForUser:(WBUser *)user
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (WBUser *)currentUser {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
  return nil;
}

+ (WBUser *)createUser {
 return [[[self class] sharedInstance] createUser];
}

- (WBUser *)createUser {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
  return nil;
}

- (void)saveUser:(WBUser *)user
         success:(void(^)(void))success
         failure:(void(^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (void)setUpWithLauchOptions:(NSDictionary *)launchOptions {
    [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

+ (WBPhoto *)createPhoto {
  return [[[self class] sharedInstance] createPhoto];
}

- (WBPhoto *)createPhoto {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
  return nil;
}

#pragma mark - Photos

- (void)uploadPhoto:(WBPhoto *)photo
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure
           progress:(void(^)(int percentDone))progress {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (void)latestPhotos:(void(^)(NSArray *photos))success
             failure:(void(^)(NSError *error))failure {
    [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (void)addComment:(NSString *)comment
           onPhoto:(WBPhoto *)photo
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

@end
