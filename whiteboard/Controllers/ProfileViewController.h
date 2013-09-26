//
//  ProfileViewController.h
//  whiteboard
//
//  Created by lnf-fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoTimelineViewController.h"
#import "WBDataSource.h"

@interface ProfileViewController : WBPhotoTimelineViewController
@property (nonatomic, strong) WBUser *user;
- (void)setupDataForUser:(WBUser *)user;

@end
