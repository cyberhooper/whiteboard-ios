//
//  UIImageView+RoundedCorners.m
//  whiteboard
//
//  Created by prs-fueled on 9/12/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "UIImageView+RoundedCorners.h"

@implementation UIImageView (RoundedCorners)

- (UIImageView *)roundedCornersWithRadius:(CGFloat)radius {
  UIImageView *imageView = self;
  imageView.layer.cornerRadius = radius;
  imageView.clipsToBounds = YES;
  
  return imageView;
}

@end
