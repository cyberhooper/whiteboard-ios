//
//  main.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/6/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UserFactory.h"

int main(int argc, char * argv[]) {
  @autoreleasepool {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *userImplementation = [mainBundle infoDictionary][@"UserImplementation"];
    Class userClass = NSClassFromString(userImplementation);
    [UserFactory initWithUserClass:userClass];
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
