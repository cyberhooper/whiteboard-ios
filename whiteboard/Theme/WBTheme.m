//
//  WBTheme.m
//  whiteboard
//
//  Created by lnf-fueled on 9/12/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBTheme.h"
#import "UIColor+Hex.h"

@interface WBTheme()

/**
	Dictionary to store the contents of the plist so the file contents only need to be loaded once.
 */
@property (nonatomic, strong) NSDictionary *themeDict;


@end

@implementation WBTheme

+ (WBTheme *)sharedTheme {
  static WBTheme *sharedTheme = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedTheme = [[self alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WBTheme" ofType:@"plist"];
    sharedTheme.themeDict = [NSDictionary dictionaryWithContentsOfFile:path];
  });
  return sharedTheme;
}

- (UIImage *)backgroundImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"backgroundImage"]];
}

- (UIImage *)sectionLikeButtonNormalImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"SECTION_likeButtonImage-Normal"]];
}

- (UIImage *)sectionLikeButtonSelectedImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"SECTION_likeButtonImage-Selected"]];
}

- (UIImage *)sectionCommentButtonNormalImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"SECTION_commentButtonImage-Normal"]];
}

- (UIFont *)sectionDisplayNameFont {
  return [UIFont fontWithName:[self.themeDict objectForKey:@"SECTION_displayNameFont"] size:[[self.themeDict objectForKey:@"SECTION_displayNameFontSize"] floatValue]];
}

- (UIColor *)sectionDisplayNameFontColor {
  return [UIColor colorWithHex:[self.themeDict objectForKey:@"SECTION_displayNameFontColor"]];
}

- (UIFont *)sectionDateNameFont {
  return [UIFont fontWithName:[self.themeDict objectForKey:@"SECTION_dateFont"] size:[[self.themeDict objectForKey:@"SECTION_dateFontSize"] floatValue]];
}

- (UIColor *)sectionDateNameFontColor {
  return [UIColor colorWithHex:[self.themeDict objectForKey:@"SECTION_dateFontColor"]];
}

- (UIFont *)sectionLikeFont {
  return [UIFont fontWithName:[self.themeDict objectForKey:@"SECTION_likeFont"] size:[[self.themeDict objectForKey:@"SECTION_likeFontSize"] floatValue]];
}

- (UIColor *)sectionLikeFontColor {
  return [UIColor colorWithHex:[self.themeDict objectForKey:@"SECTION_likeFontColor"]];
}
- (UIColor *)sectionLikeHighlightedFontColor {
  return [UIColor colorWithHex:[self.themeDict objectForKey:@"SECTION_likeHighlightedFontColor"]];
}

- (UIFont *)sectionCommentFont {
  return [UIFont fontWithName:[self.themeDict objectForKey:@"SECTION_commentFont"] size:[[self.themeDict objectForKey:@"SECTION_commentFontSize"] floatValue]];
}

- (UIColor *)sectionCommentFontColor {
  return [UIColor colorWithHex:[self.themeDict objectForKey:@"SECTION_commentFontColor"]];
}

- (UIImage *)tabBarHomeButtonNormalImage {
  UIImage *image = [UIImage imageNamed:[self.themeDict objectForKey:@"tabBarHomeButtonImage-Normal"]];
  return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)tabBarHomeButtonSelectedImage {
  UIImage *image = [UIImage imageNamed:[self.themeDict objectForKey:@"tabBarHomeButtonImage-Selected"]];
  return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)tabBarActivityButtonNormalImage {
  UIImage *image = [UIImage imageNamed:[self.themeDict objectForKey:@"tabBarActivityButtonImage-Normal"]];
  return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)tabBarActivityButtonSelectedImage {
  UIImage *image = [UIImage imageNamed:[self.themeDict objectForKey:@"tabBarActivityButtonImage-Selected"]];
  return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)tabBarBackgroundImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"tabBarBackgroundImage"]];
}

- (UIImage *)tabBarSelectedItemImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"tabBarSelectedItemImage"]];
}

- (UIImage *)tabBarCameraButtonNormalImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"tabBarCameraButtonImage-Normal"]];
}

- (UIImage *)tabBarCameraButtonSelectedImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"tabBarCameraButtonImage-Selected"]];
}

- (UIColor *)tabBarNormalFontColor {
  return [UIColor colorWithHex:[self.themeDict objectForKey:@"tabBarTextColor-Normal"]];
}

- (UIColor *)tabBarSelectedFontColor {
  return [UIColor colorWithHex:[self.themeDict objectForKey:@"tabBarTextColor-Selected"]];
}

- (UIImage *)navBarBackgroundImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"NAVBAR_backgroundImage"]];
}

- (UIImage *)feedPlaceholderImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"FEED_placeholderImage"]];
}

@end