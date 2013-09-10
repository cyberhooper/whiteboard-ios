//
//  WBUser.h
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 WBUser is the basic "User" protocol for the application.
 This protocol should be implemented by a concrete class that the developer creates.
 Any class that implements WBUser should have the properties listed in this protocol, but can define others, as well.
 */
@protocol WBUser <NSObject>

/**
 The unique ID representing this WBUser. 
 Represented as a string because some frameworks (ex. Facebook) might have alphanumeric IDs.
 */
@property (nonatomic, strong) NSString *userID;

/**
 The name that will be displayed in the UI throughout the app.
 */
@property (nonatomic, strong) NSString *displayName;

/**
 The username used to log into the app.
 */
@property (nonatomic, strong) NSString *userName;

/**
 The user's first name. Stored when the user signs up or changes his/her account info.
 */
@property (nonatomic, strong) NSString *firstName;

/**
 The user's last name. Stored when the user signs up or changes his/her account info.
 */
@property (nonatomic, strong) NSString *lastName;

/**
 The user's email address. Used to reset the password and to sign up for the app.
 */
@property (nonatomic, strong) NSString *email;

/**
 The URL of the user's medium sized profile picture image. The image at this location should be loaded asynchronously in the app.
 */
@property (nonatomic, strong) NSURL *profilePictureMediumURL;

/**
 The URL of the user's small profile picture image. The image at this location should be loaded asynchronously in the app.
 */
@property (nonatomic, strong) NSURL *profilePictureSmallURL;

/**
 The date this user's account was created.
 */
@property (nonatomic, strong) NSDate *createdAt;

/**
 The date this user's account was last updated.
 */
@property (nonatomic, strong) NSDate *updatedAt;

/**
 The number of users that are following this user.
 */
@property (nonatomic, strong) NSNumber *numberOfFollowers;

/**
 The number of users that are being followed by this user.
 */
@property (nonatomic, strong) NSNumber *numberFollowing;

@end
