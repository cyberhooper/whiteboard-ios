//
//  NSNotification+Keyboard.m
//  whiteboard
//
//  Created by prs-fueled on 8/28/13.
//  Copyright (c) 2013 Feldmann Samuelsen. All rights reserved.
//

#import "NSNotification+Keyboard.h"

@implementation NSNotification (Keyboard)

- (NSTimeInterval)keyboardAnimationDuration {
  NSDictionary* info = [self userInfo];
  NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSTimeInterval duration = 0;
  [value getValue:&duration];
  return duration;
}

@end
