//
//  WBPhotoDetailsCellAddComment.m
//  whiteboard
//
//  Created by prs-fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsCellAddComment.h"

@interface WBPhotoDetailsCellAddComment()
@property (nonatomic, weak) IBOutlet UITextField *commentTextField;
@property (nonatomic, weak) IBOutlet UIImageView *addCommentIconImageView;
@end

@implementation WBPhotoDetailsCellAddComment

#pragma mark - Setup
- (void)setupView {
  [super setupView];
  
  // Textfield
  self.commentTextField.background = [[WBTheme sharedTheme] detailsTextfieldBackgroundImage];
  
  // Icon
  self.addCommentIconImageView.image = [[WBTheme sharedTheme] detailsAddCommentIconImage];
  
  // Default
  self.seperatorBottom = NO;
}

#pragma mark - CellHeight
+ (CGFloat)cellHeight {
  return 44.f;
}

@end
