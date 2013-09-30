//
//  WBParsePushNotificationCreator.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/26/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBParsePushNotificationCreator.h"
#import <Parse/Parse.h>
#import "WBUser.h"
#import "WBPhoto.h"

@implementation WBParsePushNotificationCreator

- (id)init {
  if (self = [super init])
    [self registerForNotifications];
  return self;
}

- (void)dealloc {
  [self unRegisterForNotifications];
}
   
- (void)registerForNotifications {
  [self registerForDidLikePhoto];
  [self registerForDidFollowUsers];
}

- (void)unRegisterForNotifications {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForDidLikePhoto {
  [[NSNotificationCenter defaultCenter] addObserverForName:@"didLikePhoto" object:nil queue:nil usingBlock:^(NSNotification *note) {
    WBUser *user = [note userInfo][@"user"];
    WBPhoto *photo = [note userInfo][@"photo"];
    
    NSString *message = [NSString stringWithFormat:@"%@ likes your photo",user.displayName];
    NSDictionary *payload = @{@"alert" : message,
                              @"type" : @"like",
                              @"fromUser": user.userID,
                              @"photoId" : photo.photoID};
    NSString *authorChannel = [NSString stringWithFormat:@"user_%@",photo.author.userID];
    [self sendNotificationWithPayload:payload onChannels:@[authorChannel]];
  }];
}

- (void)registerForDidFollowUsers {
  [[NSNotificationCenter defaultCenter] addObserverForName:@"didFollowUsers" object:nil queue:nil usingBlock:^(NSNotification *note) {
    WBUser *user = [note userInfo][@"user"];
    NSArray *followedUsers = [note userInfo][@"followedUsers"];
    
    NSString *message = [NSString stringWithFormat:@"%@ is now following you",user.displayName];
    NSDictionary *payload = @{@"alert" : message,
                              @"type" : @"follow",
                              @"fromUser": user.userID};
    NSMutableArray *channels = [@[] mutableCopy];
    for (WBUser *u in followedUsers) {
      [channels addObject:[NSString stringWithFormat:@"user_%@",u.userID]];
    }
    
    [channels addObject:[NSString stringWithFormat:@"user_%@",user.userID]];
    [self sendNotificationWithPayload:payload onChannels:channels];
  }];
}

- (void)registerForDidCommentPhoto {
  [[NSNotificationCenter defaultCenter] addObserverForName:@"didCommentPhoto" object:nil queue:nil usingBlock:^(NSNotification *note) {
    WBUser *user = [note userInfo][@"user"];
    WBPhoto *photo = [note userInfo][@"photo"];
    
    NSString *message = [NSString stringWithFormat:@"%@ commented on your photo",user.displayName];
    NSDictionary *payload = @{@"alert" : message,
                              @"type" : @"comment",
                              @"fromUser": user.userID,
                              @"photoId" : photo.photoID};
    NSString *authorChannel = [NSString stringWithFormat:@"user_%@",photo.author.userID];
    [self sendNotificationWithPayload:payload onChannels:@[authorChannel]];
  }];
}

- (void)sendNotificationWithPayload:(NSDictionary *)payload onChannels:(NSArray *)channels {
  PFPush *push = [[PFPush alloc] init];
  [push setChannels:channels];
  [push setData:payload];
  [push sendPushInBackground];
}


@end
