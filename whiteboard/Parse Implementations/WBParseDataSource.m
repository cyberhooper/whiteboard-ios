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
  _currentUser.avatar = [user objectForKey:@"avatar"];
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
  [pfUser setObject:_currentUser.avatar forKey:@"avatar"];
  [pfUser setObject:_currentUser.numberOfFollowers forKey:@"numberOfFollowers"];
  [pfUser setObject:_currentUser.numberFollowing forKey:@"numberFollowing"];
  
  return pfUser;
}

- (WBUser *)createUser {
  return [[WBUser alloc] init];
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

- (void)latestPhotos:(void(^)(NSArray *photos))success
             failure:(void(^)(NSError *error))failure {
  PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
  query.limit = 20;
  [query orderByDescending:@"createdAt"];
  [query includeKey:@"user"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
    if (!error) {
      if (success) {
        NSArray *wbPhotos = [self wbPhotosFromParsePhotos:photos];
        success(wbPhotos);
      }
    } else {
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
  }];
  
  // filter with friends example :
  //[query whereKey:@"user" containedIn:[currentUser friends]];
  
  //Restrict results. Faster?
  //[query selectKeys:@[@"playerName", @"score"]];
}

- (NSArray *)wbPhotosFromParsePhotos:(NSArray *)parsePhotos {
  NSMutableArray *wbPhotos = [@[] mutableCopy];
  for (PFObject *photo in parsePhotos) {
    WBPhoto *wbPhoto = [self wbPhotoFromParsePhoto:photo];
    [wbPhotos addObject:wbPhoto];
  }
  return [NSArray arrayWithArray:wbPhotos];
}

- (WBPhoto *)wbPhotoFromParsePhoto:(PFObject *)parsePhoto {
  WBPhoto *wbPhoto = [[WBPhoto alloc] init];
  PFFile *imageFile = [parsePhoto objectForKey:@"imageFile"];
  wbPhoto.url = [NSURL URLWithString:[imageFile url]];
  PFUser *user = [parsePhoto objectForKey:@"user"];
  wbPhoto.author = [self wbUserFromParseUser:user];
  wbPhoto.createdAt = parsePhoto.createdAt;
  wbPhoto.likes = [parsePhoto objectForKey:@"likes"];
  NSLog(@"Photo : %@", [wbPhoto description]);
  return wbPhoto;
}

- (WBUser *)wbUserFromParseUser:(PFUser *)parseUser {
  WBUser *wbUser = [self createUser];
  wbUser.username = parseUser.username;
  PFFile *avatarFile = [parseUser objectForKey:@"avatar"];
  wbUser.avatar = [NSURL URLWithString:[avatarFile url]];
  NSLog(@"User : %@", [wbUser description]);
  return wbUser;
}

@end
