//
//  WBTheme.m
//  whiteboard
//
//  Created by lnf-fueled on 9/12/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBTheme.h"

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

+ (UIColor *)uiColorFromHexString:(NSString *)hexString {
#warning implement me!
  return nil;
}

- (UIImage *)backgroundImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"backgroundImage"]];
}

- (UIImage *)likeButtonNormalImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"likeButtonImage-Normal"]];
}

- (UIImage *)likeButtonSelectedImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"likeButtonImage-Selected"]];
}

- (UIImage *)commentButtonNormalImage {
  return [UIImage imageNamed:[self.themeDict objectForKey:@"commentButtonImage-Normal"]];
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

@end