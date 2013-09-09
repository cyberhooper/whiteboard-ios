//
//  main.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/6/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WBUserFactory.h"

int main(int argc, char * argv[]) {
  @autoreleasepool {
    
    // Inject <User> concrete class. 
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *userImplementation = [mainBundle infoDictionary][@"UserImplementation"];
    Class userClass = NSClassFromString(userImplementation);
    [WBUserFactory initWithUserClass:userClass];
    
    
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
