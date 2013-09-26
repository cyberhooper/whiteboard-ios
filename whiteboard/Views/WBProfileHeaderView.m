//
//  WBProfileHeaderView.m
//  whiteboard
//
//  Created by lnf-fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBProfileHeaderView.h"

@implementation WBProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
    }
    return self;
}

#pragma mark - Setup

- (void)setUpViewWithUser:(WBUser *)user {
  self.strokeImage.image = [[WBTheme sharedTheme] strokeProfilePictureImage];
  self.followImage.image = [[WBTheme sharedTheme] pictoFollowImage];
  self.pictureImage.image = [[WBTheme sharedTheme] pictoPhotoImage];
  
  [self.nameLabel setText:user.displayName];
  
  NSURL *avatar = user.avatar;
  CALayer *layer = [self.profilePictureImageView layer];
  layer.cornerRadius = 10.0f;
  layer.masksToBounds = YES;
  [self.profilePictureImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:avatar]]];
  [[WBDataSource sharedInstance] numberOfFollowersForUser:user success:^(int numberOfFollowers) {
    self.numberFollowersLabel.text = [NSString stringWithFormat:@"%d followers", numberOfFollowers];
  } failure:^(NSError *error) {}];
  [[WBDataSource sharedInstance] numberOfFollowingsForUser:user success:^(int numberOfFollowings) {
    self.numberFollowingLabel.text = [NSString stringWithFormat:@"%d following", numberOfFollowings];
  } failure:^(NSError *error) {}];
  [[WBDataSource sharedInstance]numberOfPhotosForUser:user success:^(int numberOfPhotos) {
    self.numberPicturesLabel.text = [NSString stringWithFormat:@"%d photos", numberOfPhotos];
  } failure:^(NSError *error) {}];

}

@end
