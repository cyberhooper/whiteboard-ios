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

@dynamic numberFollowing;

- (void)setProfilePictureMediumURL:(NSURL *)profilePictureMediumURL {
  self.parseProfilePictureMediumURL = [profilePictureMediumURL absoluteString];
}

@end
