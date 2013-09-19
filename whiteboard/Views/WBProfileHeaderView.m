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
  CALayer *layer = [self.profilePictureImageView layer];
  layer.cornerRadius = 10.0f;
  layer.masksToBounds = YES;
  [self.profilePictureImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:avatar]]];
  [[WBDataSource sharedInstance] numberOfFollowersForUser:[WBDataSource currentUser] success:^(int numberOfFollowers) {
    self.numberFollowersLabel.text = [NSString stringWithFormat:@"%d followers", numberOfFollowers];
  } failure:^(NSError *error) {}];
  [[WBDataSource sharedInstance] numberOfFollowingsForUser:[WBDataSource currentUser] success:^(int numberOfFollowings) {
    self.numberFollowingLabel.text = [NSString stringWithFormat:@"%d following", numberOfFollowings];
  } failure:^(NSError *error) {}];
  [[WBDataSource sharedInstance]numberOfPhotosForUser:[WBDataSource currentUser] success:^(int numberOfPhotos) {
    self.numberPicturesLabel.text = [NSString stringWithFormat:@"%d photos", numberOfPhotos];
  } failure:^(NSError *error) {}];

}

@end
