//  ParseDataSource.m
//  whiteboard
//
//  Created by sad-fueled on 9/10/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBParseDataSource.h"
#import <Parse/Parse.h>
#import "WBComment.h"
#import "WBUser+PFUser.h"
#import "PFUser+WBUser.h"
#import "WBPhoto+PFObject.h"
#import "PFObject+WBPhoto.h"
#import "WBComment+PFObject.h"
#import "PFObject+WBComment.h"
#import "PFObject+WBActivity.h"
#import "WBAccountManager.h"
#import "WBParseConstants.h"
#import "WBActivity.h"
#import "WBParsePushNotificationCreator.h"

@implementation WBParseDataSource {
  WBParsePushNotificationCreator *pushNotificationCreator;
}

@synthesize currentUser = _currentUser;
@synthesize facebookFriends = _facebookFriends;

- (id)init {
  if (self = [super init]) {
    pushNotificationCreator = [[WBParsePushNotificationCreator alloc] init];
  }
  return self;
}

- (void)dealloc {
  pushNotificationCreator = nil;
}

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
  _currentUser = [[PFUser currentUser] WBUser];
  return _currentUser;
}

- (void)saveUser:(WBUser *)user
         success:(void(^)(void))success
         failure:(void(^)(NSError *error))failure {
  PFUser *pfUser = [user PFUser];
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
  [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
      PFObject *parsePhoto = [self parsePhotoWithImageFile:imageFile];
      parsePhoto.ACL = [self photoACL];
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
    
- (PFACL *)photoACL {
  PFACL *acl = [PFACL ACLWithUser:[PFUser currentUser]];
  [acl setPublicReadAccess:YES];
  ///
  [acl setPublicWriteAccess:YES];
  return acl;
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
  PFQuery *query = [PFQuery orQueryWithSubqueries:@[[self queryForcurrentUserPhotos], [self queryForCurentUserFriendPhotos]]];
  query.limit = self.photoLimit;
  query.skip = offset;
  [query orderByDescending:@"createdAt"];
  [query includeKey:@"user"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
    if (!error && success)
      success([self wbPhotosFromParsePhotos:photos]);
    else if (failure)
      failure(error);
  }];
}

- (PFQuery*)queryForcurrentUserPhotos {
  PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
  if ([PFUser currentUser])
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
  return query;
}

- (PFQuery *)queryForCurentUserFriendPhotos {
  PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
  if ([PFUser currentUser]) {
    PFRelation *followingRelation = [[PFUser currentUser] relationforKey:@"following"];
    [query whereKey:@"user" matchesQuery:[followingRelation query]];
  }
  return query;
}

- (void)photosForUser:(WBUser *)wbUser
          withOffset:(int)offset
              success:(void(^)(NSArray *photos))success
              failure:(void(^)(NSError *error))failure {
  PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
  query.limit = 100;
  query.skip = offset;
  [query orderByDescending:@"createdAt"];
  [query includeKey:@"user"];
  PFUser *parseUser = [PFUser objectWithoutDataWithClassName:@"_User" objectId:wbUser.userID];
  [query whereKey:@"user" equalTo:parseUser];
  [query findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
    if (!error && success)
      success([self wbPhotosFromParsePhotos:photos]);
    else  if (failure)
      failure(error);
  }];
}

- (void)likePhoto:(WBPhoto *)photo
        withUser:(WBUser *)user
         success:(void (^)(NSArray *likes))success
         failure:(void (^)(NSError *))failure {
  PFObject *parsePhoto = [PFObject objectWithoutDataWithClassName:@"Photo" objectId:photo.photoID];
  PFObject *parseUser = [PFUser objectWithoutDataWithClassName:@"_User" objectId:user.userID];
  [parsePhoto addUniqueObject:parseUser forKey:@"likes"];
  [parsePhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded && success) {
      WBPhoto *responsePhoto = [parsePhoto WBPhoto];
      success(responsePhoto.likes);
      [self createLikeActivityForPhoto:parsePhoto];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"didLikePhoto" object:nil userInfo:@{@"user": user, @"photo": photo}];
    } else if (failure) {
      failure(error);
    }
  }];
}

- (void)unlikePhoto:(WBPhoto *)photo
           withUser:(WBUser *)user
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure {
  PFObject *parsePhoto = [PFObject objectWithoutDataWithClassName:@"Photo" objectId:photo.photoID];
  PFObject *parseUser = [PFUser objectWithoutDataWithClassName:@"_User" objectId:user.userID];
  [parsePhoto removeObject:parseUser forKey:@"likes"];
  [parsePhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded && success) {
      success();
      [self deletePossiblePreviouslikeActivityForPhoto:parsePhoto];
    } else if (failure) {
      failure(error);
    }
  }];
}

- (void)fetchPhoto:(WBPhoto *)photo
           success:(void(^)(WBPhoto *fetchedPhoto))success
           failure:(void(^)(NSError *error))failure {
  PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
  [query includeKey:@"user"];
  [query includeKey:@"likes"];
  [query includeKey:@"comments.user"];
  [query getObjectInBackgroundWithId:photo.photoID block:^(PFObject *parsePhoto, NSError *error) {
    if (!error && success) {
      success([parsePhoto WBPhoto]);
    }
  }];
}

- (NSArray *)wbPhotosFromParsePhotos:(NSArray *)parsePhotos {
  NSMutableArray *wbPhotos = [@[] mutableCopy];
  for (PFObject *photo in parsePhotos) {
    WBPhoto *wbPhoto = [photo WBPhoto];
    [wbPhotos addObject:wbPhoto];
  }
  return [NSArray arrayWithArray:wbPhotos];
}

- (NSArray *)wbUsersFromParseUsers:(NSArray *)parseUsers {
  NSMutableArray *wbUsers = [@[] mutableCopy];
  for (PFUser *user in parseUsers) {
    [user fetchIfNeeded];
    WBUser *wbUser = [user WBUser];
    [wbUsers addObject:wbUser];
  }
  return [NSArray arrayWithArray:wbUsers];
}

- (void)deletePhoto:(WBPhoto *)photo
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure {  
  PFObject *photoToDelete = [PFObject objectWithoutDataWithClassName:@"Photo" objectId:photo.photoID];
  [photoToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded && success)
      success();
    else if (failure)
      failure(error);
  }];
}

#pragma mark - Comments

- (void)addComment:(NSString *)comment
           onPhoto:(WBPhoto *)photo
           success:(void(^)(void))success
           failure:(void(^)(NSError *error))failure {
  NSDictionary * params = @{@"comment" : comment, @"photoId" : photo.photoID };
  [PFCloud callFunctionInBackground:@"addCommentToPhoto" withParameters:params block:^(id object, NSError *error) {
    if (!error && success) {
      success();
     [self createCommentActivityForPhoto:object];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"didCommentPhoto" object:nil userInfo:@{@"user": [self currentUser], @"photo": photo}];
    }
    else if (failure) {
      failure(error);
    }
  }];
}

#pragma mark - Follow 

- (void)suggestedUsers:(void(^)(NSArray *suggestedUsers))success
               failure:(void(^)(NSError *error))failure {
  // if the Facebook friend array is nil, get the friends from the account manager, then tag them
  [[WBAccountManager sharedInstance] getFacebookFriends:^(NSArray *friends) {
    [WBDataSource sharedInstance].facebookFriends = friends;
    [self tagUsersAsFollowed:[WBDataSource sharedInstance].facebookFriends success:^(NSArray *suggestedUsers) {
      if (success) {
        success(suggestedUsers);
      }
    } failure:^(NSError *error) {
      if (failure) {
        failure(error);
      }
    }];
  } failure:nil];
}

- (void)tagUsersAsFollowed:(NSArray *)users
                   success:(void(^)(NSArray *suggestedUsers))success
                   failure:(void(^)(NSError *error))failure {
  /// Tag users as followed or not.
  PFRelation *followingRelation = [[PFUser currentUser] relationforKey:@"following"];
  [[followingRelation query] findObjectsInBackgroundWithBlock:^(NSArray *followedUsers, NSError *error) {
    if (error && failure) {
      failure(error);
    } else if (success) {
      for (WBUser *wbUser in users) {
        for (PFUser *followedUser in followedUsers) {
          if ([followedUser.objectId isEqualToString:wbUser.userID]) {
            wbUser.isFollowed = YES;
          }
        }
      }
      success(users);
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
  NSMutableArray *parseUsers = [@[]mutableCopy];
  for (WBUser *wbUser in wbUsers) {
    PFUser *userToFollow = [PFUser objectWithoutDataWithClassName:@"_User" objectId:wbUser.userID];
    [followingRelation addObject:userToFollow];
    [parseUsers addObject:userToFollow];
  }
  [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error && success) {
      success();
      [self createFollowActivityForUsers:parseUsers];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"didFollowUsers" object:nil userInfo:@{@"user" : [self currentUser] ,@"followedUsers": wbUsers}];
    }
    else if (failure) {
      failure(error);
    }
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
  NSMutableArray *parseUsers = [@[]mutableCopy];
  for (WBUser *wbUser in wbUsers) {
    PFUser *userToUnFollow = [PFUser objectWithoutDataWithClassName:@"_User" objectId:wbUser.userID];
    [followingRelation removeObject:userToUnFollow];
    [parseUsers addObject:userToUnFollow];
  }
  [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error && success) {
      success();
      [self deletePossiblePreviousFollowActivityForUsers:parseUsers];
    }
    else if (failure) {
      failure(error);
    }
  }];
}

#pragma mark - Profile

- (void)profileForUser:(WBUser *)wbUser
               success:(void(^)(WBUser *user))success
               failure:(void(^)(NSError *error))failure {
  PFQuery *query = [PFQuery queryWithClassName:@"_User"];
  [query getObjectInBackgroundWithId:wbUser.userID block:^(PFObject *user, NSError *error) {
    if (!error && success)
      success([(PFUser*)user WBUser]);
    else if (failure)
      failure(error);
  }];
}

- (void)numberOfPhotosForUser:(WBUser *)user
                      success:(void(^)(int numberOfPhotos))success
                      failure:(void(^)(NSError *error))failure {
  PFUser *parseUser = [PFUser objectWithoutDataWithClassName:@"_User" objectId:user.userID];
  PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
  [query whereKey:@"user" equalTo:parseUser];
  [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    if (!error && success)
      success(number);
    else if (failure)
      failure(error);
  }];
}

- (void)numberOfFollowersForUser:(WBUser *)user
                         success:(void(^)(int numberOfFollowers))success
                         failure:(void(^)(NSError *error))failure {
  PFUser *pfUser = [PFUser objectWithoutDataWithClassName:@"_User" objectId:user.userID];
  PFQuery *query = [PFQuery queryWithClassName:@"_User"];
  [query whereKey:@"following" equalTo:pfUser];
  [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    if (!error && success)
      success(number);
    else if (failure)
      failure(error);
  }];
}

- (void)numberOfFollowingsForUser:(WBUser *)user
                          success:(void(^)(int numberOfFollowings))success
                          failure:(void(^)(NSError *error))failure {
  PFUser *pfUser = [PFUser objectWithoutDataWithClassName:@"_User" objectId:user.userID];
  PFRelation *followingRelation = [pfUser relationforKey:@"following"];
  [[followingRelation query] countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    if (!error && success)
      success(number);
    else if (failure)
      failure(error);
  }];
}

#pragma mark - Activities

- (void)createLikeActivityForPhoto:(PFObject *)photo {
  PFObject *activity = [PFObject objectWithClassName:@"Activity"];
  [activity setObject:kActivityTypeLike forKey:kActivityTypeKey];
  [activity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
  [activity setObject:[photo objectForKey:@"user"] forKey:kActivityToUserKey];
  [activity setObject:photo forKey:kActivityPhotoKey];
  [activity saveInBackground];
}

- (void)deletePossiblePreviouslikeActivityForPhoto:(PFObject *)photo {
  PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
  [query whereKey:kActivityTypeKey equalTo:kActivityTypeLike];
  [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
  [query whereKey:@"photo" equalTo:photo];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    for (PFObject *o in objects) {
      [o deleteInBackground];
    }
  }];
}

- (void)createFollowActivityForUsers:(NSArray *)users {
  for (PFObject *user in users) {
    PFObject *activity = [PFObject objectWithClassName:@"Activity"];
    [activity setObject:kActivityTypeFollow forKey:kActivityTypeKey];
    [activity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [activity setObject:user forKey:kActivityToUserKey];
    [activity saveInBackground];
  }
}

- (void)deletePossiblePreviousFollowActivityForUsers:(NSArray *)users {
  for (PFObject *user in users) {
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:kActivityTypeKey equalTo:kActivityTypeFollow];
    [query whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kActivityToUserKey equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      for (PFObject *o in objects) {
        [o deleteInBackground];
      }
    }];
  }
}

- (void)createCommentActivityForPhoto:(PFObject *)photo {
  PFObject *activity = [PFObject objectWithClassName:@"Activity"];
  [activity setObject:kActivityTypeComment forKey:kActivityTypeKey];
  [activity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
  [activity setObject:[photo objectForKey:@"user"] forKey:kActivityToUserKey];
  [activity setObject:photo forKey:kActivityPhotoKey];
  [activity saveInBackground];
}

#pragma mark - Activity feed

- (void)recentActivities:(void(^)(NSArray *activities))success
                 failure:(void(^)(NSError *error))failure {
  PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
  [query whereKey:kActivityToUserKey equalTo:[PFUser currentUser]];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error && success) {
      success([self wbActivitiesFromActivities:objects]);
    }
    else if (failure) {
      failure(error);
    }
  }];
}

- (NSArray *)wbActivitiesFromActivities:(NSArray *)activities {
  NSMutableArray *wbActivities = [@[] mutableCopy];
  for (PFObject *a in activities) {
    [wbActivities addObject:[a WBActivity]];
  }
  return [NSArray arrayWithArray:wbActivities];
}
              
@end
