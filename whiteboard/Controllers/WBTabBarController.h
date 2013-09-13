//
//  WBTabBarController.h
//  whiteboard
//
//  Created by lnf-fueled on 9/13/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainFeedViewController.h"
#import "WBTheme.h"

@interface WBTabBarController : UITabBarController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UINavigationController *homeNavigationController;
@property (nonatomic, strong) UINavigationController *emptyMiddleNavigationController;
@property (nonatomic, strong) UINavigationController *activityNavigationController;

@end
