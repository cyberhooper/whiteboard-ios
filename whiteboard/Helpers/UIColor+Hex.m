//
//  UIColor+Hex.m
//  whiteboard
//
//  Created by prs-fueled on 9/13/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)
+ (UIColor *)colorWithHex:(NSString *)str {
  return [UIColor colorWithHex:str andAlpha:1.0];
}

+ (UIColor *)colorWithHex:(NSString *)str andAlpha:(float)alpha {
  const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
  long x = strtol(cStr+1, NULL, 16);
  
  unsigned char r, g, b;
  b = x & 0xFF;
  g = (x >> 8) & 0xFF;
  r = (x >> 16) & 0xFF;
  return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:alpha];
}
@end
