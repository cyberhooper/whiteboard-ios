//
//  UIImageView+WBImageLoader.m
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "UIImageView+SLImageLoader.h"
//#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation UIImageView (WBImageLoader)

- (void)setImageWithPath:(NSString *)path placeholder:(UIImage *)placeholder {
  [self setImageWithPath:path
        placeholderImage:placeholder
                 success:nil
                 failure:nil];
}

- (void)setImageWithPath:(NSString *)path
        placeholderImage:(UIImage *)placeholderImage
                 success:(void (^)(UIImage *image))success
                 failure:(void (^)(NSError *error))failure {
  
//  NSURL *url = [NSURL URLWithString:path];
//  NSURLRequest *request = [NSURLRequest requestWithURL:url];
//  
//  [self setImageWithURLRequest:request
//              placeholderImage:placeholderImage
//                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                         if(success){
//                           success(image);
//                         }
//                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                         if(failure){
//                           failure(error);
//                         }
//                       }];
}

- (void)cancelDownload {
//  [self cancelImageRequestOperation];
}

@end
