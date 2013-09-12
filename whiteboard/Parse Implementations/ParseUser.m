//
//  ZUser.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "ParseUser.h"
#import <Parse/PFObject+Subclass.h>

@interface ParseUser ()

@property (nonatomic, strong) NSString *parseProfilePictureMediumURL;

@end

@implementation ParseUser

@synthesize userID;
@synthesize displayName;
@synthesize firstName;
@synthesize lastName;
@synthesize profilePictureSmallURL;
@synthesize profilePictureMediumURL;
@synthesize parseProfilePictureMediumURL;
@synthesize numberOfFollowers;
@synthesize numberFollowing;


// Automatic synthesize is not require for now since those exist inPFUSer with the same name.
// It might cause an issue later if the types mismatch.

//username;
//email;
//profilePictureMediumURL;
//profilePictureSmallURL;
//createdAt;
//updatedAt;

@end
