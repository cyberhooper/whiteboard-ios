//
//  WBNavigationController.h
//  whiteboard
//
//  Created by lnf-fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBNavigationController : UINavigationController <UIActionSheetDelegate>
@property BOOL showSettingsButton;
- (void)setUpSettingsButton;
- (void)showSettingsButton:(BOOL)value;

@end
