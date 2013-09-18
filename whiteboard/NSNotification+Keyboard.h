//
//  NSNotification+Keyboard.h
//  whiteboard
//
//  Created by prs-fueled on 8/28/13.
//  Copyright (c) 2013 Feldmann Samuelsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotification (Keyboard)
/**
 Returns the duration of the keyboard to be shown/hidden
 */
- (NSTimeInterval)keyboardAnimationDuration;
@end
