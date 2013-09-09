//
//  WBPhotoTimelineSectionHeaderView.m
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoTimelineSectionHeaderView.h"

@interface WBPhotoTimelineSectionHeaderView()
@property (nonatomic, weak) IBOutlet UILabel *displayNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profilePictureImageView;
@end

@implementation WBPhotoTimelineSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

#pragma mark - Setters
- (void)setDisplayName:(NSString *)displayName {
  _displayName = displayName;
  
  self.displayNameLabel.text = displayName;
}

- (void)setDate:(NSDate *)date {
  _date = date;
  
  self.dateLabel.text = @"1 day ago";
}

- (void)setProfilePictureImage:(UIImage *)profilePictureImage {
  _profilePictureImage = profilePictureImage;
  
  self.profilePictureImageView.image = profilePictureImage;
}

@end
