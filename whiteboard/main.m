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
#import "WBDataSource.h"

int main(int argc, char * argv[]) {
  @autoreleasepool {
    

    NSBundle *mainBundle = [NSBundle mainBundle];
    
    // Inject <WBUser> concrete class.
    NSString *userImplementation = [mainBundle infoDictionary][@"UserImplementation"];
    Class userClass = NSClassFromString(userImplementation);
    [WBUserFactory initWithUserClass:userClass];
    
    
    // Inject |WBDatasource| subclass.
    NSString *dataSourceImplementation = [mainBundle infoDictionary][@"DataSourceImplementation"];
    Class dataSourceClass = NSClassFromString(dataSourceImplementation);
    [WBDataSource initWithDataSourceSubclass:dataSourceClass];
    
    
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
