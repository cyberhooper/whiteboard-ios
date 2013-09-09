//
//  User.h
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WBUser <NSObject>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSURL *profilePictureMediumURL;
@property (nonatomic, strong) NSURL *profilePictureSmallURL;
@property (nonatomic) BOOL isLoggedIn;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSNumber *numberOfFollowers;
@property (nonatomic, strong) NSNumber *numberFollowing;

@end
