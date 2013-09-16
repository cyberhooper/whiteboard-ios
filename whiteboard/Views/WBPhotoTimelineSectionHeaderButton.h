//
//  WBPhotoTimelineSectionHeaderButton.h
//  whiteboard
//
//  Created by prs-fueled on 9/13/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBPhotoTimelineSectionHeaderButton;

@protocol WBPhotoTimelineSectionHeaderButtonDelegate <NSObject>
- (void)wbPhotoTimelineSectionHeaderButtonPressed:(WBPhotoTimelineSectionHeaderButton *)button;
@end

@interface WBPhotoTimelineSectionHeaderButton : UIView

/**
 The image to be displayed in the view in normal state
 */
@property (nonatomic, strong) UIImage *normalImage;

/**
 The image to be displayed in the view in highlighted state
 */
@property (nonatomic, strong) UIImage *highlightedImage;

/**
 The image to be displayed in the view in selected state
 */
@property (nonatomic, strong) UIImage *selectedImage;

/**
 The number label to be displayed inside the button
 */
@property (nonatomic, strong) UILabel *numberLabel;

/**
 The delegate for this class
 */
@property (nonatomic, weak) id<WBPhotoTimelineSectionHeaderButtonDelegate> delegate;

@end
