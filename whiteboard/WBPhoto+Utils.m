//
//  WBPhoto+Utils.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhoto+Utils.h"
#import "WBDataSource.h"

@implementation WBPhoto (Utils)

- (BOOL)isLiked {
  return [self.likes containsObject:[[WBDataSource sharedInstance] currentUser]];
}

- (BOOL)isMine {
  return [self.author isEqual:[[WBDataSource sharedInstance] currentUser]];
}

@end