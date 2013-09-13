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

@end