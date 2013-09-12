//
//  WBPhotoTimelineSectionHeaderView.m
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoTimelineSectionHeaderView.h"
#import "UIImageView+RoundedCorners.h"
#import <FormatterKit/TTTTimeIntervalFormatter.h>

@interface WBPhotoTimelineSectionHeaderView()
@property (nonatomic, weak) IBOutlet UILabel *displayNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UILabel *likeNumberLabel;
@property (nonatomic, weak) IBOutlet UIButton *commentButton;
@property (nonatomic, weak) IBOutlet UILabel *commentNumberLabel;
@end

@implementation WBPhotoTimelineSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self setupView];
}

#pragma mark - Setup
- (void)setupView {
  // Defaults
  [self.profilePictureImageView roundedCornersWithRadius:3.f];
}

#pragma mark - Setters
- (void)setDisplayName:(NSString *)displayName {
  _displayName = displayName;
  
  self.displayNameLabel.text = displayName;
}

- (void)setDate:(NSDate *)date {
  _date = date;
  
  TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
  self.dateLabel.text = [timeIntervalFormatter stringForTimeIntervalFromDate:date toDate:[NSDate date]];
}

- (void)setNumberOfLikes:(NSNumber *)numberOfLikes {
  _numberOfLikes = numberOfLikes;
  
  self.likeNumberLabel.text = [NSString stringWithFormat:@"%d", numberOfLikes.intValue];
}

- (void)setNumberOfComments:(NSNumber *)numberOfComments {
  _numberOfComments = numberOfComments;

  self.commentNumberLabel.text = [NSString stringWithFormat:@"%d", numberOfComments.intValue];
}

#pragma mark - IBActions
- (IBAction)likesButtonPressed:(id)sender {
  if([self.delegate respondsToSelector:@selector(sectionHeaderLikesButtonPressed:)]){
    [self.delegate sectionHeaderLikesButtonPressed:self];
  }
}

- (IBAction)commentsButtonPressed:(id)sender {
  if([self.delegate respondsToSelector:@selector(sectionHeaderCommentsButtonPressed:)]){
    [self.delegate sectionHeaderCommentsButtonPressed:self];
  }
}

@end
