//
//  WBPhotoDetailsCellLikes.m
//  whiteboard
//
//  Created by prs-fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsCellLikes.h"
#import "WBPhotoTimelineSectionHeaderButton.h"
#import "UIImageView+WBImageLoader.h"
#import "UIImageView+RoundedCorners.h"
#import "Whiteboard.h"

#define kMaxNumberOfDisplayedLikers 7
#define kLikerImageViewSize 29.f
#define kLikerSpacing 4.f

@interface WBPhotoDetailsCellLikes()
@property (nonatomic, weak) IBOutlet WBPhotoTimelineSectionHeaderButton *likeButton;
@property (nonatomic, weak) IBOutlet UIView *likersView;
@end

@implementation WBPhotoDetailsCellLikes

#pragma mark - Setup
- (void)setupView {
  [super setupView];

  // Like button
  UIImage *normalImage = [[WBTheme sharedTheme] sectionLikeButtonNormalImage];
  UIImage *highlightedImage = [[WBTheme sharedTheme] sectionLikeButtonSelectedImage];
  UIImage *selectedImage = [[WBTheme sharedTheme] sectionLikeButtonSelectedImage];
  
  self.likeButton.normalImage = normalImage;
  self.likeButton.highlightedImage = highlightedImage;
  self.likeButton.selectedImage = selectedImage;
  
  self.likeButton.numberLabel.text = [NSString stringWithFormat:@"%i", self.likers.count];
}

#pragma mark - Setters
- (void)setLikers:(NSArray *)likers {
  _likers = likers;
  
  // Remove any previous imageviews if they exist
  for(UIView *view in self.likersView.subviews){
    [view removeFromSuperview];
  }
  
  // Add an imageview with all the likers to the likersView
  NSInteger numerOfLikers = self.likers.count > kMaxNumberOfDisplayedLikers ? kMaxNumberOfDisplayedLikers : self.likers.count;
  
  for (NSInteger i = 0; i < numerOfLikers; i++) {
    CGSize size = CGSizeMake(kLikerImageViewSize, kLikerImageViewSize);
    CGFloat spacing = i * kLikerSpacing;
    CGFloat posX = (size.width * i) + spacing;
    CGFloat posY = (self.frame.size.height / 2) - (size.height / 2);
    
    CGRect frame = CGRectMake(posX, posY, size.width, size.height);
    
    
    UIImageView *likerImageView = [[UIImageView alloc] initWithFrame:frame];
    likerImageView.clipsToBounds = YES;
    likerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [likerImageView roundedCornersWithRadius:3.f];
    
    // Get the user from the likers array
    WBUser *user = [self.likers objectAtIndex:i];
    
    // Set the avatar image
    [likerImageView setImageWithPath:user.avatar.absoluteString placeholder:nil];
    
    [self.likersView addSubview:likerImageView];
    
    
    // Detect Taps on avatars.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = i;
    [self.likersView addSubview:button];
  }
  
  [self setupView];
}

#pragma mark - CellHeight
+ (CGFloat)cellHeight {
  return 42.f;
}

- (void)tap:(UIButton *)sender  {
  if ([_delegate respondsToSelector:@selector(likesCellDidSelectAvatarAtIndex:)]) {
    [_delegate likesCellDidSelectAvatarAtIndex:sender.tag];
  }
}



@end
