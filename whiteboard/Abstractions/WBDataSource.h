//
//  WBDataSource.h
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/10/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUser.h"
#import "WBPhoto.h"

/**
  Abstract singleton class representing a DataSource.
  The developer should subclass this class for each type of DataSource (ex. Parse).
 */
@interface WBDataSource : NSObject

#pragma mark - User

@property (nonatomic, strong) WBUser *currentUser;

/**
 The limit for the amount of photos to load at a time
 */
@property (nonatomic, assign) NSInteger photoLimit;

/**
  The singleton method for creating a WBDataSource instance.
  @returns A concrete implementation of WBDataSource
 */
+ (WBDataSource *)sharedInstance;

/**
	Set the concrete subclass that the sharedInstance method should return.
	@param dataSourceSubclass The concrete DataSource implementation to return.
 */
+ (void)setDataSourceSubclass:(Class)dataSourceSubclass;


/**
 Saves a given WBUser to the server.
 This is used to edit user info.
 On failure to save, give the error back in a block.
 @param user The WBUser to save remotely
 @param success The success block
 @param failure The failure block, called with an NSError
 */
- (void)saveUser:(WBUser *)user
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure;

/**
 Get the currently logged in user
	@returns The currently logged in WBUser, or nil if no user is logged in.
 */
- (WBUser *)currentUser;

/**
 Get the currently logged in user
 @returns The currently logged in WBUser, or nil if no user is logged in.
 */
+ (WBUser *)currentUser;

/**
 Get the avatar for logged in user
 @returns The current Avatar for logged in WBUser, or nil if no user is logged in.
 */
- (NSURL *)currentAvatar;

/**
 creates a WBUser object.
 @returns The newly created WBUser
 */
+ (WBUser *)createUser;

#pragma mark - Photos
/**
 Creates a WBPhoto object.
 @returns The newly created WBPhoto
 */
+ (WBPhoto *)createPhoto;

- (void)uploadPhoto:(WBPhoto *)photo
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure
           progress:(void(^)(int percentDone))progress;

- (void)latestPhotos:(void(^)(NSArray *photos))success
             failure:(void(^)(NSError *error))failure;

- (void)latestPhotosWithOffset:(int)offset
                       success:(void(^)(NSArray *photos))success
                       failure:(void(^)(NSError *error))failure;

- (void)likePhoto:(WBPhoto *)photo
         withUser:(WBUser *)user
          success:(void(^)(void))success
          failure:(void(^)(NSError *error))failure;

- (void)unlikePhoto:(WBPhoto *)photo
         withUser:(WBUser *)user
          success:(void(^)(void))success
          failure:(void(^)(NSError *error))failure;

- (void)addComment:(NSString *)comment
           onPhoto:(WBPhoto *)photo
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure;

#pragma mark - Follow

- (void)suggestedUsers:(void(^)(NSArray *users))success
               failure:(void(^)(NSError *error))failure;

- (void)toggleFollowForUser:(WBUser *)user
                    success:(void(^)(void))success
                    failure:(void(^)(NSError *error))failure;

#pragma mark - Set Up

/**
 Method called when the app starts that enables WBDatasource to
 perform some setup code. Example, set Api key, base url etc.
 */
- (void)setUpWithLauchOptions:(NSDictionary *)launchOptions;

#pragma mark - Profile

- (void)numberOfPhotosForUser:(WBUser *)user
                      success:(void(^)(int numberOfPhotos))success
                      failure:(void(^)(NSError *error))failure;

- (void)numberOfFollowersForUser:(WBUser *)user
                      success:(void(^)(int numberOfFollowers))success
                      failure:(void(^)(NSError *error))failure;

- (void)numberOfFollowingsForUser:(WBUser *)user
                         success:(void(^)(int numberOfFollowings))success
                         failure:(void(^)(NSError *error))failure;

@end

