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
  The singleton method for creating a WBDataSource instance.
  @returns A concrete implementation of WBDataSource
 */
+ (WBDataSource *)sharedInstance;


/**
  Log in with the given username and password.
  On success give back the newly logged in WBUser in a block, otherwise give the error back in a block.
  @param username The supplied username
  @param password The supplied password
  @param success The success block, called with the new WBUser
  @param failure The failure block, called with an NSError
 */
- (void)loginWithUsername:(NSString *)username
              andPassWord:(NSString *)password
                  success:(void(^)(WBUser *user))success
                  failure:(void(^)(NSError *error))failure;


/**
	Logout the given user. On failure to log out, return the NSError in the failure block.
  @param user The user to log out
  @param success The success block
  @param failure The failure block, called with an NSError
 */
- (void)logoutUser:(WBUser *)user
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure;


/**
	Set the concrete subclass that the sharedInstance method should return.
	@param dataSourceSubclass The concrete DataSource implementation to return.
 */
+ (void)setDataSourceSubclass:(Class)dataSourceSubclass;


/**
	Sign up for a Whiteboard account with the given dictionary of user info (name, email, etc.).
  On success give back the newly logged in WBUser in a block, otherwise give the error back in a block.
	@param userInfo The user info to use when creating an account.
  @param success The success block, called with the new WBUser
  @param failure The failure block, called with an NSError
 */
- (void)signupWithInfo:(NSDictionary *)userInfo
               success:(void(^)(WBUser *user))success
               failure:(void(^)(NSError *error))failure;


/**
	Delete the given WBUser from the server. 
  On failure to delete, give the error back in a block.
	@param user The WBUser to delete
  @param success The success block
  @param failure The failure block, called with an NSError
 */
- (void)deleteUserAccount:(WBUser *)user
               success:(void(^)(void))success
               failure:(void(^)(NSError *error))failure;

/**
 reset password of the given WBUser from the server.
 On failure to reset, give the error back in a block.
 @param user The WBUser to reset password
 @param success The success block
 @param failure The failure block, called with an NSError
 */
- (void)resetPasswordForUser:(WBUser *)user
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *))failure;

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

@end

