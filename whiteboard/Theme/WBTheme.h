//
//  WBTheme.h
//  whiteboard
//
//  Created by lnf-fueled on 9/12/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
	The default theme for the application. 
 This Singleton class contains methods that return all images, fonts, and colors used in the app.
 
 */
@interface WBTheme : NSObject

/**
	The shared theme for the application.
	@returns The shared theme instance for the application.
 */
+ (WBTheme *)sharedTheme;

- (NSString *)headerImageName;

- (UIImage *)backgroundImage;

@end
