//
//  WBProfileHeaderView.m
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBProfileHeaderView.h"
#import "WBDataSource.h"

@implementation WBProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      [self setUpView];
    }
    return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self setUpView];
}

#pragma mark - Setup

- (void)setUpView {
  [self.nameLabel setText:[WBDataSource currentUser].displayName];
  NSURL *avatar = [[WBDataSource sharedInstance]currentAvatar];
  [self.profilePictureImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:avatar]]];
  self.profilePictureImageView.layer.cornerRadius = 10.0f;
  
}

@end
