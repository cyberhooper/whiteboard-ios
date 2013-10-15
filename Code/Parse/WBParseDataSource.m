//  ParseDataSource.m
//  whiteboard
//
//  Created by sad-fueled on 9/10/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBParseDataSource.h"
#import <Parse/Parse.h>
#import "WBUser+PFUser.h"
#import "PFUser+WBUser.h"
#import "WBPhoto+PFObject.h"
#import "PFObject+WBPhoto.h"
#import "WBComment+PFObject.h"
#import "PFObject+WBComment.h"
#import "PFObject+WBActivity.h"
#import "WBParseConstants.h"
#import "WBParsePushNotificationCreator.h"
#import "WBAccountManager.h"


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
  DDLogInfo(@"Set up parse");
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
    if (succeeded && success) {
      DDLogInfo(@"Save User Succedeed");
      success();
    }
    else if (failure) {
      DDLogError(@"Save User failed : %@", error);
      failure(error);
    }
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
      DDLogInfo(@"upload photo Succedeed");
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
      if (failure) {
        DDLogError(@"Upload photo failed : %@", error);
        failure(error);
      }
  } progressBlock:^(int percentDone) {
    if (progress) progress(percentDone);
  }];
}

- (PFACL *)photoACL {
  PFACL *acl = [PFACL ACLWithUser:[PFUser currentUser]];
  [acl setPublicReadAccess:YES];
  [acl setPublicWriteAccess:YES];
  return acl;
}

- (PFObject *)parsePhotoWithImageFile:(PFFile *)imageFile {
  // Create a PFObject around a PFFile and associate it with the current user
  PFObject *photo = [PFObject objectWithClassName:kPhotoClass];
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
    if (!error && success) {
      DDLogInfo(@"get latest photo Succedeed");
      success([self wbPhotosFromParsePhotos:photos]);
    } else if (failure) {
      DDLogError(@"Failed to get lastest photo : %@", error);
      failure(error);
    }
  }];
}

- (PFQuery*)queryForcurrentUserPhotos {
  PFQuery *query = [PFQuery queryWithClassName:kPhotoClass];
  if ([PFUser currentUser])
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
  return query;
}

- (PFQuery *)queryForCurentUserFriendPhotos {
  PFQuery *query = [PFQuery queryWithClassName:kPhotoClass];
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
  PFQuery *query = [PFQuery queryWithClassName:kPhotoClass];
  query.limit = 100;
  query.skip = offset;
  [query orderByDescending:@"createdAt"];
  [query includeKey:@"user"];
  PFUser *parseUser = [PFUser objectWithoutDataWithClassName:kUserClass objectId:wbUser.userID];
  [query whereKey:@"user" equalTo:parseUser];
  [query findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
    if (!error && success) {
      DDLogInfo(@"get photo for user Succedeed");
      success([self wbPhotosFromParsePhotos:photos]);
    } else  if (failure) {
      DDLogError(@"failed to get avatar : %@", error);
      failure(error);
    }
  }];
}

- (void)likePhoto:(WBPhoto *)photo
        withUser:(WBUser *)user
         success:(void (^)(void))success
         failure:(void (^)(NSError *))failure {
  PFObject *parsePhoto = [PFObject objectWithoutDataWithClassName:kPhotoClass objectId:photo.photoID];
  PFObject *parseUser = [PFUser objectWithoutDataWithClassName:kUserClass objectId:user.userID];

  [parsePhoto addUniqueObject:parseUser forKey:@"likes"];
  [parsePhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded && success) {
      DDLogInfo(@"like photo Succedeed");
      success();
      [self createLikeActivityForPhoto:photo];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"didLikePhoto" object:nil userInfo:@{@"user": user, @"photo": photo}];
    } else if (failure) {
      DDLogError(@"like photo failed : %@", error);
      failure(error);
    }
  }];
}

- (void)unlikePhoto:(WBPhoto *)photo
           withUser:(WBUser *)user
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure {
  PFObject *parsePhoto = [PFObject objectWithoutDataWithClassName:kPhotoClass objectId:photo.photoID];
  PFObject *parseUser = [PFUser objectWithoutDataWithClassName:kUserClass objectId:user.userID];
  [parsePhoto removeObject:parseUser forKey:@"likes"];
  [parsePhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded && success) {
      DDLogInfo(@"unlike photo Succedeed");
      success();
      [self deletePossiblePreviouslikeActivityForPhoto:parsePhoto];
    } else if (failure) {
      DDLogError(@"unlike photo failed : %@", error);
      failure(error);
    }
  }];
}

- (void)fetchPhoto:(WBPhoto *)photo
           success:(void(^)(WBPhoto *fetchedPhoto))success
           failure:(void(^)(NSError *error))failure {
  PFQuery *query = [PFQuery queryWithClassName:kPhotoClass];
  [query includeKey:@"user"];
  [query includeKey:@"likes"];
  [query includeKey:@"comments.user"];
  [query getObjectInBackgroundWithId:photo.photoID block:^(PFObject *parsePhoto, NSError *error) {
    if (!error && success) {
      success([parsePhoto WBPhoto]);
      DDLogInfo(@"fetch photo Succedeed");
    } else if (error) {
      DDLogError(@"fetch photo failed : %@", error);
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
  PFObject *photoToDelete = [PFObject objectWithoutDataWithClassName:kPhotoClass objectId:photo.photoID];
  [photoToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded && success) {
      DDLogInfo(@"delete photo Succedeed");
      success();
    }
    else if (failure) {
      DDLogError(@"delete photo failed : %@", error);
      failure(error);
    }
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
      DDLogInfo(@"add comment Succedeed");
      success();
      [self createCommentActivityForPhoto:object];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"didCommentPhoto" object:nil userInfo:@{@"user": [self currentUser], @"photo": photo}];
    }
    else if (failure) {
      DDLogError(@"add comment failed : %@", error);
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
        DDLogInfo(@"get suggested user Succedeed");
        success(suggestedUsers);
      }
    } failure:^(NSError *error) {
      if (failure) {
        DDLogError(@"get suggested user failed : %@", error);
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
      DDLogError(@"tag follow user failed : %@", error);
      failure(error);
    } else if (success) {
      DDLogInfo(@"tag follow user Succedeed");
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
    PFUser *userToFollow = [PFUser objectWithoutDataWithClassName:kUserClass objectId:wbUser.userID];
    [followingRelation addObject:userToFollow];
    [parseUsers addObject:userToFollow];
  }
  [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error && success) {
      for (WBUser *u in wbUsers) {
        u.isFollowed = YES;
      }
      DDLogInfo(@"follow user(s) Succedeed");
      success();
      [self createFollowActivityForUsers:parseUsers];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"didFollowUsers" object:nil userInfo:@{@"user" : [self currentUser] ,@"followedUsers": wbUsers}];
    }
    else if (failure) {
      DDLogError(@"follow user(s) Failed : %@", error);
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
    PFUser *userToUnFollow = [PFUser objectWithoutDataWithClassName:kUserClass objectId:wbUser.userID];
    [followingRelation removeObject:userToUnFollow];
    [parseUsers addObject:userToUnFollow];
  }
  [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error && success) {
      for (WBUser *u in wbUsers) {
        u.isFollowed = NO;
      }
      DDLogInfo(@"follow user(s) Succedeed");
      success();
      [self deletePossiblePreviousFollowActivityForUsers:parseUsers];
    }
    else if (failure) {
      DDLogError(@"unfollow user(s) Failed : %@", error);
      failure(error);
    }
  }];
}

- (void)isFollowed:(WBUser *)user
           success:(void(^)(BOOL isFollowed))success
           failure:(void(^)(NSError *error))failure {
  PFRelation *followingRelation = [[PFUser currentUser] relationforKey:@"following"];
  [[followingRelation query] findObjectsInBackgroundWithBlock:^(NSArray *followedUsers, NSError *error) {
    NSMutableArray *followingIds = [@[] mutableCopy];
    for (PFUser *u in followedUsers) {
      [followingIds addObject:u.objectId];
    }
    user.isFollowed = [followingIds containsObject:user.userID];
    success(user.isFollowed);
  }];
}

#pragma mark - Profile

- (void)numberOfPhotosForUser:(WBUser *)user
                      success:(void(^)(int numberOfPhotos))success
                      failure:(void(^)(NSError *error))failure {
  PFUser *parseUser = [PFUser objectWithoutDataWithClassName:kUserClass objectId:user.userID];
  PFQuery *query = [PFQuery queryWithClassName:kPhotoClass];
  [query whereKey:@"user" equalTo:parseUser];
  [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    if (!error && success) {
      DDLogInfo(@"get number of photo for an user Succedeed");
      success(number);
    }
    else if (failure) {
      DDLogError(@"get number of photo for an user Failed : %@", error);
      failure(error);
    }
  }];
}

- (void)numberOfFollowersForUser:(WBUser *)user
                         success:(void(^)(int numberOfFollowers))success
                         failure:(void(^)(NSError *error))failure {
  PFUser *pfUser = [PFUser objectWithoutDataWithClassName:kUserClass objectId:user.userID];
  PFQuery *query = [PFQuery queryWithClassName:kUserClass];
  [query whereKey:@"following" equalTo:pfUser];
  [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    if (!error && success) {
      DDLogInfo(@"get number of followers for an user Succedeed");
      success(number);
    }
    else if (failure) {
      DDLogError(@"get number of followers for an user Failed : %@", error);
      failure(error);
    }
  }];
}

- (void)numberOfFollowingsForUser:(WBUser *)user
                          success:(void(^)(int numberOfFollowings))success
                          failure:(void(^)(NSError *error))failure {
  PFUser *pfUser = [PFUser objectWithoutDataWithClassName:kUserClass objectId:user.userID];
  PFRelation *followingRelation = [pfUser relationforKey:@"following"];
  [[followingRelation query] countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    if (!error && success) {
      DDLogInfo(@"get number of following for an user Succedeed");
      success(number);
    }
    else if (failure) {
      DDLogError(@"get number of following for an user Failed : %@", error);
      failure(error);
    }
  }];
}

#pragma mark - Activities

- (void)createLikeActivityForPhoto:(WBPhoto *)photo {
  if (![photo.author isEqual:[self currentUser]]) {
    PFObject *activity = [PFObject objectWithClassName:kActivityClass];
    [activity setObject:kActivityTypeLike forKey:kActivityTypeKey];
    [activity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    PFObject *pfPhoto = [PFObject objectWithoutDataWithClassName:kPhotoClass objectId:photo.photoID];
    PFObject *author = [PFObject objectWithoutDataWithClassName:kUserClass objectId:photo.author.userID];
    [activity setObject:author forKey:kActivityToUserKey];
    [activity setObject:pfPhoto forKey:kActivityPhotoKey];
    [activity saveInBackground];
  }
}

- (void)deletePossiblePreviouslikeActivityForPhoto:(PFObject *)photo {
  PFQuery *query = [PFQuery queryWithClassName:kActivityClass];
  [query whereKey:kActivityTypeKey equalTo:kActivityTypeLike];
  [query whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
  [query whereKey:kActivityPhotoKey equalTo:photo];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    for (PFObject *o in objects) {
      [o deleteInBackground];
    }
  }];
}

- (void)createFollowActivityForUsers:(NSArray *)users {
  for (PFObject *user in users) {
    PFObject *activity = [PFObject objectWithClassName:kActivityClass];
    [activity setObject:kActivityTypeFollow forKey:kActivityTypeKey];
    [activity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [activity setObject:user forKey:kActivityToUserKey];
    [activity saveInBackground];
  }
}

- (void)deletePossiblePreviousFollowActivityForUsers:(NSArray *)users {
  for (PFObject *user in users) {
    PFQuery *query = [PFQuery queryWithClassName:kActivityClass];
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
  PFObject *author = [photo objectForKey:@"user"];
  
  if (![author.objectId isEqualToString:[self currentUser].userID]) {
    PFObject *activity = [PFObject objectWithClassName:kActivityClass];
    [activity setObject:kActivityTypeComment forKey:kActivityTypeKey];
    [activity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [activity setObject:[photo objectForKey:@"user"] forKey:kActivityToUserKey];
    [activity setObject:photo forKey:kActivityPhotoKey];
    [activity saveInBackground];
  }
}

#pragma mark - Activity feed

- (void)recentActivities:(void(^)(NSArray *activities))success
                 failure:(void(^)(NSError *error))failure {
  PFQuery *query = [PFQuery queryWithClassName:kActivityClass];
  [query whereKey:kActivityToUserKey equalTo:[PFUser currentUser]];
  [query includeKey:kActivityFromUserKey];
  [query includeKey:kActivityPhotoKey];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error && success) {
      DDLogInfo(@"get recent activities Succedeed");
      success([self wbActivitiesFromActivities:objects]);
    }
    else if (failure) {
      DDLogError(@"get recent activities Failed : %@", error);
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

- (WBActivity *)wbActivityfromActivity:(PFObject *)object {
  WBActivity *activity = [[WBActivity alloc] init];
  activity.type = [object objectForKey:kActivityTypeKey];
  PFUser *fromUser = [object objectForKey:kActivityFromUserKey];
  activity.fromUser = [fromUser WBUser];
  activity.createdAt = object.createdAt;
  
  if ([activity.type isEqualToString:kActivityTypeLike] || [activity.type isEqualToString:kActivityTypeComment]) {
    PFObject *photo = [object objectForKey:@"photo"];
    activity.photo = [photo WBPhoto];
  }
  return activity;
}

#pragma mark - Push Notifications.

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [PFPush storeDeviceToken:deviceToken];
  
  if (application.applicationIconBadgeNumber != 0) {
    application.applicationIconBadgeNumber = 0;
  }
  
  [[PFInstallation currentInstallation] addUniqueObject:@"" forKey:@"channels"];
  
  if ([PFUser currentUser]) {
    // Make sure they are subscribed to their private push channel
    NSString *privateChannelName = [[PFUser currentUser] objectForKey:@"channel"];
    if (privateChannelName && privateChannelName.length > 0) {
      NSLog(@"Subscribing user to %@", privateChannelName);
      [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:@"channels"];
    }
  }
  // Save the added channel(s)
  [[PFInstallation currentInstallation] saveEventually];
}
@end
