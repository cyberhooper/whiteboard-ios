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
#import "WBDataSource.h"
#import "WBNavigationController.h"

@interface WBTabBarController : UITabBarController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) WBNavigationController *homeNavigationController;
@property (nonatomic, strong) WBNavigationController *emptyMiddleNavigationController;
@property (nonatomic, strong) WBNavigationController *activityNavigationController;

@end
