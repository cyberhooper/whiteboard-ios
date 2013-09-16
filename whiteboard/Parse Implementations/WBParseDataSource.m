//
//  ParseDataSource.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/10/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBParseDataSource.h"
#import <Parse/Parse.h>

@implementation WBParseDataSource

@synthesize currentUser = _currentUser;

- (void)setUpWithLauchOptions:(NSDictionary *)launchOptions {
  [Parse setApplicationId:[self applicationId]
                clientKey:[self clientKey]];
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

- (NSString *)applicationId {
  return [self configurationDictionary][@"ApplicationId"];
}

- (NSString *)clientKey {
  return [self configurationDictionary][@"ClientKey"];
}

- (NSDictionary *)configurationDictionary {
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *configurationPath = [mainBundle pathForResource:@"ParseConfiguration" ofType:@"plist"];
  return [NSDictionary dictionaryWithContentsOfFile:configurationPath];
}

- (void)loginWithUsername:(NSString *)username
              andPassWord:(NSString *)password
                  success:(void (^)(WBUser *))success
                  failure:(void (^)(NSError *))failure {

  [PFUser logInWithUsernameInBackground:username
                               password:password
                                  block:^(PFUser *user, NSError *error) {
                                    if (user) {
                                      [self mapCurrentWBUser:user];
                                      success([self currentUser]);
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
  _currentUser = nil;
  [PFUser logOut];
  success();
}

- (void)signupWithInfo:(NSDictionary *)userInfo
               success:(void (^)(WBUser *))success
               failure:(void (^)(NSError *))failure {
  PFUser *pfCurrentUser = [PFUser user];
  [pfCurrentUser setUsername:[userInfo objectForKey:@"userName"]];
  [pfCurrentUser setPassword:[userInfo objectForKey:@"password"]];
  [pfCurrentUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
      [self mapCurrentWBUser:pfCurrentUser];
      success(_currentUser);
    }
    else {
      failure (error);
    }
  }];
}

- (WBUser *)currentUser {
  [self mapCurrentWBUser:[PFUser currentUser]];
  return _currentUser;
}

- (void)deleteUserAccount:(WBUser *)user
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure {
  PFUser *pfUser = [self mapPFUser:user];
  [pfUser deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (success && succeeded) {
      _currentUser = nil;
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

- (void)saveUser:(WBUser *)user
         success:(void(^)(void))success
         failure:(void(^)(NSError *error))failure {
  PFUser *pfUser = [self mapPFUser:user];
  [pfUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded && success)
      success();
    else if (failure)
      failure(error);
  }];
}

- (void)mapCurrentWBUser:(PFUser *)user {
  if (!_currentUser) {
    _currentUser = [self createUser];
  }
  _currentUser.userID = user.objectId;
  _currentUser.displayName = user.username;
  _currentUser.username = user.username;
  _currentUser.firstName = [user objectForKey:@"firstname"];
  _currentUser.lastName = [user objectForKey:@"lastname"];
  _currentUser.email = [user email];
  _currentUser.profilePictureMediumURL = [user objectForKey:@"profilePictureMediumURL"];
  _currentUser.profilePictureSmallURL = [user objectForKey:@"profilePictureSmallURL"];
  _currentUser.createdAt = user.createdAt;
  _currentUser.updatedAt = user.updatedAt;
  _currentUser.numberOfFollowers = [user objectForKey:@"numberOfFollowers"];
  _currentUser.numberFollowing = [user objectForKey:@"numberFollowing"];
}

- (PFUser *)mapPFUser:(WBUser *)user {
  PFUser *pfUser = [PFUser user];
  
  pfUser.objectId = _currentUser.userID;
  pfUser.username = _currentUser.displayName;
  pfUser.username = _currentUser.username;
  [pfUser setObject:_currentUser.firstName forKey:@"firstname"];
  [pfUser setObject:_currentUser.lastName forKey:@"lastName"];
  pfUser.email = _currentUser.email;
  [pfUser setObject:_currentUser.profilePictureMediumURL forKey:@"profilePictureMediumURL"];
  [pfUser setObject:_currentUser.profilePictureSmallURL forKey:@"profilePictureSmallURL"];
  [pfUser setObject:_currentUser.numberOfFollowers forKey:@"numberOfFollowers"];
  [pfUser setObject:_currentUser.numberFollowing forKey:@"numberFollowing"];
  
  return pfUser;
}

- (WBUser *)createUser {
  return [[WBUser alloc] init];;
}

#pragma mark - Photos

- (WBPhoto *)createPhoto {
  return [[WBPhoto alloc] init];
}

- (void)uploadPhoto:(WBPhoto *)photo
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure
           progress:(void(^)(int percentDone))progress {
  NSData *imageData = UIImageJPEGRepresentation(photo.image, 1);
  PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
  
  // Save PFFile
  [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      PFObject *parsePhoto = [self parsePhotoWithImageFile:imageFile];
      [parsePhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error && success)
          success();
        else if (failure)
          failure(error);
      }];
    }
    else
      if (failure) failure(error);
  } progressBlock:^(int percentDone) {
    if (progress) progress(percentDone);
  }];
}

- (PFObject *)parsePhotoWithImageFile:(PFFile *)imageFile {
  // Create a PFObject around a PFFile and associate it with the current user
  PFObject *photo = [PFObject objectWithClassName:@"Photo"];
  [photo setObject:imageFile forKey:@"imageFile"];
  photo.ACL = [PFACL ACLWithUser:[PFUser currentUser]]; // Set the access control list to current user for security purposes
  PFUser *user = [PFUser currentUser];
  [photo setObject:user forKey:@"user"];
  return photo;
}

@end
