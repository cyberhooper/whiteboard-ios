//
//  AppDelegate.h
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/6/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, weak) IBOutlet WBTabBarController *tabBarController;

@end
