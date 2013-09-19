//  ParseDataSource.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/10/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBParseDataSource.h"
#import <Parse/Parse.h>
#import "WBComment.h"
#import "WBUser+ParseUser.h"

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

- (WBUser *)currentUser {
  _currentUser = [WBUser mapWBUser:[PFUser currentUser]];
  return _currentUser;
}

- (void)saveUser:(WBUser *)user
         success:(void(^)(void))success
         failure:(void(^)(NSError *error))failure {
  PFUser *pfUser = [WBUser mapPFUser:user];
  [pfUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded && success)
      success();
    else if (failure)
      failure(error);
  }];
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
  PFUser *user = [PFUser currentUser];
  [photo setObject:user forKey:@"user"];
  return photo;
}

- (void)latestPhotos:(void(^)(NSArray *photos))success
             failure:(void(^)(NSError *error))failure {
  [self latestPhotosWithOffset:0 success:success failure:failure];
}

- (void)latestPhotosWithOffset:(int)offset
                       success:(void(^)(NSArray *photos))success
                       failure:(void(^)(NSError *error))failure {
  PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
  query.limit = self.photoLimit;
  query.skip = offset;
  [query orderByDescending:@"createdAt"];
  [query includeKey:@"user"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
    if (!error && success)
      success([self wbPhotosFromParsePhotos:photos]);
    else
      NSLog(@"Error: %@ %@", error, [error userInfo]);
  }];
}
// filter with friends example :
//[query whereKey:@"user" containedIn:[currentUser friends]];

//Restrict results. Faster?
//[query selectKeys:@[@"playerName", @"score"]];

- (void)likePhoto:(WBPhoto *)photo
         withUser:(WBUser *)user
          success:(void(^)(void))success
          failure:(void(^)(NSError *error))failure {
  NSArray *likes = photo.likes;
  if (photo.likes) {
    if (![photo.likes containsObject:user.userID]) {
      likes = [photo.likes arrayByAddingObject:user.userID];
    }
  } else {
    likes = @[user.userID];
  }
  PFObject *parsePhoto = [PFObject objectWithoutDataWithClassName:@"Photo" objectId:photo.photoID];
  [parsePhoto setObject:likes forKey:@"likes"];
  [parsePhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded && success) {
      photo.likes = likes;
      success();
    } else if (failure) {
      failure(error);
    }
  }];
}

- (void)unlikePhoto:(WBPhoto *)photo
           withUser:(WBUser *)user
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure {
  NSMutableArray *likes = [NSMutableArray arrayWithArray:photo.likes];
  if ([likes containsObject:user.userID]) {
    [likes removeObject:user.userID];
  }
  PFObject *parsePhoto = [PFObject objectWithoutDataWithClassName:@"Photo" objectId:photo.photoID];
  [parsePhoto setObject:likes forKey:@"likes"];
  [parsePhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded && success) {
      photo.likes = likes;
      success();
    } else if (failure) {
      failure(error);
    }
  }];
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
  
  NSMutableArray *comments = [@[] mutableCopy];
  for (PFObject *parseComment in [parsePhoto objectForKey:@"comments"]) {
    WBComment *comment = [[WBComment alloc] init];
    comment.commentID = parseComment.objectId;
    [comments addObject:comment];
  }
  wbPhoto.comments = comments;
  wbPhoto.photoID = parsePhoto.objectId;
  NSLog(@"Photo : %@", [wbPhoto description]);
  return wbPhoto;
}

- (NSArray *)wbUsersFromParseUsers:(NSArray *)parseUsers {
  NSMutableArray *wbUsers = [@[] mutableCopy];
  for (PFUser *user in parseUsers) {
    WBUser *wbUser = [self wbUserFromParseUser:user];
    [wbUsers addObject:wbUser];
  }
  return [NSArray arrayWithArray:wbUsers];
}

- (WBUser *)wbUserFromParseUser:(PFUser *)parseUser {
  WBUser *wbUser = [self createUser];
  wbUser.userID = parseUser.objectId;
  wbUser.displayName = [parseUser objectForKey:@"displayName"];
  PFFile *avatarFile = [parseUser objectForKey:@"avatar"];
  wbUser.avatar = [NSURL URLWithString:[avatarFile url]];
  NSLog(@"User : %@", [wbUser description]);
  return wbUser;
}

- (void)addComment:(NSString *)comment
           onPhoto:(WBPhoto *)photo
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure {
  
  if (![PFUser currentUser]) {
    if (failure) {
      NSError *e = [NSError errorWithDomain:@"" code:0 userInfo:@{@"mesages" : @"You need to be logged in to post a comment"}];
      failure(e);
    }
    return;
  }
  
  PFObject *parseComment = [PFObject objectWithClassName:@"Comment"];
  [parseComment setObject:comment forKey:@"text"];
  [parseComment setObject:[PFUser currentUser] forKey:@"user"];
  PFObject *parsePhoto = [PFObject objectWithoutDataWithClassName:@"Photo" objectId:photo.photoID];
  [parsePhoto addObject:parseComment forKey:@"comments"];
  
  [parsePhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error && success)
      success();
    else if (failure)
      failure(error);
  }];
}

#pragma mark - Follow 

- (void)suggestedUsers:(void(^)(NSArray *suggestedUsers))success
               failure:(void(^)(NSError *error))failure {
  PFQuery *query = [PFQuery queryWithClassName:@"_User"];
  [query orderByAscending:@"displayName"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
    if (!error && success) {
      NSArray *wbUsers = [self wbUsersFromParseUsers:users];
      
      /// Tag users as followed or not.
      PFRelation *followingRelation = [[PFUser currentUser] relationforKey:@"following"];
      [[followingRelation query] findObjectsInBackgroundWithBlock:^(NSArray *followedUsers, NSError *error) {
        if (error && failure) {
          failure(error);
        } else if (success) {
          for (WBUser *wbUser in wbUsers) {
            for (PFUser *followedUser in followedUsers) {
              if ([followedUser.objectId isEqualToString:wbUser.userID]) {
                wbUser.isFollowed = YES;
              }
            }
          }
          success(wbUsers);
        }
      }];
    }
    else if (failure) {
      failure(error);
    }
  }];
}

- (void)toggleFollowForUser:(WBUser *)user
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure {
  if (!user.isFollowed)
    [self followUser:user success:success failure:failure];
  else
    [self unFollowUser:user success:success failure:failure];
}

- (void)followUser:(WBUser *)user
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure {
  [self followUsers:@[user] success:success failure:failure];
}

- (void)followUsers:(NSArray *)wbUsers
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure {
  PFUser *currentUser = [PFUser currentUser];
  PFRelation *followingRelation = [currentUser relationforKey:@"following"];
  for (WBUser *wbUser in wbUsers) {
    PFUser *userToFollow = [PFUser objectWithoutDataWithClassName:@"_User" objectId:wbUser.userID];
    [followingRelation addObject:userToFollow];
  }
  [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error && success)
      success();
    else if (failure)
      failure(error);
  }];
}

- (void)unFollowUser:(WBUser *)user
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure {
  [self unFollowUsers:@[user] success:success failure:failure];
}

- (void)unFollowUsers:(NSArray *)wbUsers
              success:(void(^)(void))success
              failure:(void(^)(NSError *error))failure {
  PFUser *currentUser = [PFUser currentUser];
  PFRelation *followingRelation = [currentUser relationforKey:@"following"];
  for (WBUser *wbUser in wbUsers) {
    PFUser *userToUnFollow = [PFUser objectWithoutDataWithClassName:@"_User" objectId:wbUser.userID];
    [followingRelation removeObject:userToUnFollow];
  }
  [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error && success)
      success();
    else if (failure)
      failure(error);
  }];
}

#pragma mark - Profile

- (void)profileForUser:(WBUser *)wbUser
               success:(void(^)(WBUser *user))success
               failure:(void(^)(NSError *error))failure {
  PFQuery *query = [PFQuery queryWithClassName:@"_User"];
  [query getObjectInBackgroundWithId:wbUser.userID block:^(PFObject *user, NSError *error) {
    if (!error && success)
      success([self wbUserFromParseUser:(PFUser*)user]);
    else if (failure)
      failure(error);
  }];
}

- (void)numberOfPhotosForUser:(WBUser *)user
                      success:(void(^)(int numberOfPhotos))success
                      failure:(void(^)(NSError *error))failure {
  PFUser *parseUser = [PFUser objectWithoutDataWithClassName:@"_User" objectId:user.userID];
  PFQuery *queryPhotoCount = [PFQuery queryWithClassName:@"Photo"];
  [queryPhotoCount whereKey:@"user" equalTo:parseUser];
  queryPhotoCount.cachePolicy = kPFCachePolicyCacheElseNetwork;
  [queryPhotoCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    if (!error && success)
      success(number);
    else if (failure)
      failure(error);
  }];
}

- (void)numberOfFollowersForUser:(WBUser *)user
                         success:(void(^)(int numberOfFollowers))success
                         failure:(void(^)(NSError *error))failure {
  PFUser *parseUser = [PFUser objectWithoutDataWithClassName:@"_User" objectId:user.userID];
  PFRelation *followerRelation = [parseUser relationforKey:@"follower"];
  [[followerRelation query] countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    if (!error && success)
      success(number);
    else if (failure)
      failure(error);
  }];
}

- (void)numberOfFollowingsForUser:(WBUser *)user
                          success:(void(^)(int numberOfFollowings))success
                          failure:(void(^)(NSError *error))failure {
  PFUser *parseUser = [PFUser objectWithoutDataWithClassName:@"_User" objectId:user.userID];
  PFRelation *followingRelation = [parseUser relationforKey:@"following"];
  [[followingRelation query] countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    if (!error && success)
      success(number);
    else if (failure)
      failure(error);
  }];
}

@end
