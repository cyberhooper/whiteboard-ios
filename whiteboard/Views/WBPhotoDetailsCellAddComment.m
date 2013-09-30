//
//  WBPhotoDetailsCellAddComment.m
//  whiteboard
//
//  Created by prs-fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsCellAddComment.h"

@interface WBPhotoDetailsCellAddComment() <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *addCommentIconImageView;
@property (nonatomic, weak) IBOutlet UITextField *commentTextField;
@end

@implementation WBPhotoDetailsCellAddComment

#pragma mark - Setup
- (void)setupView {
  [super setupView];
  
  // Textfield
  self.commentTextField.background = [[WBTheme sharedTheme] detailsTextfieldBackgroundImage];
  self.commentTextField.delegate = self;
  
  // Icon
  self.addCommentIconImageView.image = [[WBTheme sharedTheme] detailsAddCommentIconImage];
  
  // Default
  self.seperatorBottom = NO;
}

#pragma mark - CellHeight
+ (CGFloat)cellHeight {
  return 44.f;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if ([self.delegate respondsToSelector:@selector(commentCell:didTapSendWithText:)]) {
    [self.delegate commentCell:self didTapSendWithText:self.commentTextField.text];
  }
  return YES;
}

- (void)clearTextField {
  self.commentTextField.text = @"";
  [self.commentTextField resignFirstResponder];
}

@end
