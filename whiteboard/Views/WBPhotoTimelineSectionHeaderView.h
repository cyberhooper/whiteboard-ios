//
//  WBPhotoTimelineSectionHeaderView.h
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBPhotoTimelineSectionHeaderButton.h"
#import "WBUser.h"

@class WBPhotoTimelineSectionHeaderView;

@protocol WBPhotoTimelineSectionHeaderViewDelegate <NSObject>
@optional
- (void)sectionHeaderCommentsButtonPressed:(WBPhotoTimelineSectionHeaderView *)sectionView;
- (void)sectionHeaderLikesButtonPressed:(WBPhotoTimelineSectionHeaderView *)sectionView;
- (void)sectionHeaderPressed:(WBUser *)author;
@end

@interface WBPhotoTimelineSectionHeaderView : UIView

/**
 The author of the photo currently displayed
 */
@property (nonatomic, strong) WBUser *author;

/**
 The date since the post was created
 */
@property (nonatomic, copy) NSDate *date;

/**
 The users profile picture
 */
@property (nonatomic, weak) IBOutlet UIImageView *profilePictureImageView;

/**
 Sets the number of likes
 */
@property (nonatomic, strong) NSNumber *numberOfLikes;

/**
 Sets the number of comments
 */
@property (nonatomic, strong) NSNumber *numberOfComments;

/**
 The delegate for this class
 */
@property (nonatomic, weak) id<WBPhotoTimelineSectionHeaderViewDelegate> delegate;

@property (nonatomic, strong) NSNumber *sectionIndex;

@property (nonatomic) BOOL isLiked;

@property (nonatomic, weak) IBOutlet WBPhotoTimelineSectionHeaderButton *likeButton;

/**
 The image of the like button in normal state
 */
- (UIImage *)likeButtonImage;

/**
 The image of the like button in highlighted state
 */
- (UIImage *)likeButtonImageHighlighted;

/**
 The image of the like button in selected state
 */
- (UIImage *)likeButtonImageSelected;

/**
 The image of the comment button in normal state
 */
- (UIImage *)commentButtonImage;

/**
 The image of the comment button in highlighted state
 */
- (UIImage *)commentButtonImageHighlighted;

/**
 The image of the comment button in selected state
 */
- (UIImage *)commentButtonImageSelected;
@end