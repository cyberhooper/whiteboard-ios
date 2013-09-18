//
//  KeyboardAnimationTableView.m
//  whiteboard
//
//  Created by Petter Samuelsen on 31.08.13.
//  Copyright (c) 2013 Feldmann Samuelsen. All rights reserved.
//

#import "KeyboardAnimationView.h"
#import "NSNotification+Keyboard.h"

typedef enum {
  TableViewAnimationDirectionUp = 0,
  TableViewAnimationDirectionDown
} TableViewAnimationDirection;

@implementation KeyboardAnimationView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  
  if (self) {
    [self setupKeyboardNotifications];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  if (self) {
    [self setupKeyboardNotifications];
  }
  return self;
}

#pragma mark - Keyboard Notifications

- (void)setupKeyboardNotifications {
  // Add keyboard observers
  [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification *note) {
                                                  [self animateViewWithDirection:TableViewAnimationDirectionUp
                                                                    notification:note];
                                                }];
  
  [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification *note) {
                                                  [self animateViewWithDirection:TableViewAnimationDirectionDown
                                                                    notification:note];
                                                }];
}

- (void)animateViewWithDirection:(TableViewAnimationDirection)direction
                    notification:(NSNotification *)notification {
  // Get the size of the keyboard.
  CGSize keyboardSize = [[[notification userInfo] objectForKey:
                          UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  CGRect viewFrame = [self frame];
  
  if(direction == TableViewAnimationDirectionUp){
    viewFrame.size.height -= keyboardSize.height;
  }else{
    viewFrame.size.height += keyboardSize.height;
  }
  
  // Animate the tableView frame height
  [UIView animateWithDuration:[notification keyboardAnimationDuration]
                   animations:^{
                     self.frame = viewFrame;
                   } completion:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
