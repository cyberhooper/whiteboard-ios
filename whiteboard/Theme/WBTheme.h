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
	@returns The shared WBTheme instance for the application.
 */
+ (WBTheme *)sharedTheme;

/**
	The default background image for most screens. Specified in the plist as "backgroundImage".
	@returns The default background image
 */
- (UIImage *)backgroundImage;

/**
	The default Like button image. Specified in the plist as "likeButtonImage-Normal".
	@returns The default Like button image
 */
- (UIImage *)sectionLikeButtonNormalImage;

/**
	The default Like button image when the button is selected. Specified in the plist as "likeButtonImage-Selected".
	@returns The default selected Like button image
 */
- (UIImage *)sectionLikeButtonSelectedImage;

/**
	The default Comment button image. Specified in the plist as "commentButtonImage-Normal".
	@returns The default Comment button image
 */
- (UIImage *)sectionCommentButtonNormalImage;

/**
 The default font for the section display name. Specified in the plist as "SECTION_displayNameFont".
 @returns The default font for the section display name
 */
- (UIFont *)sectionDisplayNameFont;

- (UIColor *)sectionDisplayNameFontColor;

- (UIFont *)sectionDateNameFont;

- (UIColor *)sectionDateNameFontColor;

- (UIImage *)tabBarHomeButtonNormalImage;
- (UIImage *)tabBarHomeButtonSelectedImage;
- (UIImage *)tabBarActivityButtonNormalImage;
- (UIImage *)tabBarActivityButtonSelectedImage;
- (UIImage *)tabBarBackgroundImage;
- (UIImage *)tabBarSelectedItemImage;
- (UIImage *)tabBarCameraButtonNormalImage;
- (UIImage *)tabBarCameraButtonSelectedImage;

- (UIColor *)tabBarNormalFontColor;
- (UIColor *)tabBarSelectedFontColor;

@end