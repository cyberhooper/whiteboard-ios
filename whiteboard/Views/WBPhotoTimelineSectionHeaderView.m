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
@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UILabel *commentsLabel;
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
  
  self.dateLabel.text = [date description];
}

- (void)setProfilePictureImage:(UIImage *)profilePictureImage {
  _profilePictureImage = profilePictureImage;
  
  self.profilePictureImageView.image = profilePictureImage;
}

- (void)setNumberOfLikes:(NSNumber *)numberOfLikes {
  _numberOfLikes = numberOfLikes;
  
  [self.likeButton setTitle:[NSString stringWithFormat:@"%d", numberOfLikes.intValue] forState:UIControlStateNormal];
}

- (void)setNumberOfComments:(NSNumber *)numberOfComments {
  _numberOfComments = numberOfComments;
  
  self.commentsLabel.text = [NSString stringWithFormat:@"%d", numberOfComments.intValue];
}

@end
