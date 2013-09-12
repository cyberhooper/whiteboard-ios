//
//  WBPhotoTimelineSectionHeaderView.h
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBPhotoTimelineSectionHeaderView;

@protocol WBPhotoTimelineSectionHeaderViewDelegate <NSObject>
- (void)sectionHeaderCommentsButtonPressed:(WBPhotoTimelineSectionHeaderView *)sectionView;
- (void)sectionHeaderLikesButtonPressed:(WBPhotoTimelineSectionHeaderView *)sectionView;
@end

@interface WBPhotoTimelineSectionHeaderView : UIView

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, weak) IBOutlet UIImageView *profilePictureImageView;
@property (nonatomic, strong) NSNumber *numberOfLikes;
@property (nonatomic, strong) NSNumber *numberOfComments;
@property (nonatomic, weak) id<WBPhotoTimelineSectionHeaderViewDelegate> delegate;

@end
