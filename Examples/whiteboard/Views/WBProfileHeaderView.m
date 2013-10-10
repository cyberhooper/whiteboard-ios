//
//  WBProfileHeaderView.m
//  whiteboard
//
//  Created by lnf-fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBProfileHeaderView.h"

@implementation WBProfileHeaderView

+ (UIView *)view {
  NSString *nibName = NSStringFromClass([self class]);
  return [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil][0];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.strokeImage.image = [[WBTheme sharedTheme] strokeProfilePictureImage];
  self.followImage.image = [[WBTheme sharedTheme] pictoFollowImage];
  self.pictureImage.image = [[WBTheme sharedTheme] pictoPhotoImage];
  self.profilePictureImageView.layer.cornerRadius = 10.0f;
  self.profilePictureImageView.layer.masksToBounds = YES;
}

@end
