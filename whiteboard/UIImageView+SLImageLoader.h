//
//  UIImageView+WBImageLoader.h
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WBImageLoader)

/**
 Loads the image and sets a placeholder image while loading
 */
- (void)setImageWithPath:(NSString *)path placeholder:(UIImage *)placeholder;

/**
 Loads the image and sets a placeholder image while loading and returns success and failure
 */
- (void)setImageWithPath:(NSString *)path
        placeholderImage:(UIImage *)placeholderImage
                 success:(void (^)(UIImage *image))success
                 failure:(void (^)(NSError *error))failure;

/**
 Cancels the download if one exists
 */
- (void)cancelDownload;

@end
