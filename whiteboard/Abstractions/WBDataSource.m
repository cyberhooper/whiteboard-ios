
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


+ (void)setDataSourceSubclass:(Class)dataSourceSubclass {
  DataSourceSubclass = dataSourceSubclass;
}

+ (WBUser *)currentUser {
  return [[[self class] sharedInstance] currentUser];
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

- (void)likePhoto:(WBPhoto *)photo
         withUser:(WBUser *)user
          success:(void(^)(void))success
          failure:(void(^)(NSError *error))failure {
  [NSException raise:@"You should override in a WBDataSource subclass" format:nil];
}

- (void)unlikePhoto:(WBPhoto *)photo
           withUser:(WBUser *)user
            success:(void(^)(void))success
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
