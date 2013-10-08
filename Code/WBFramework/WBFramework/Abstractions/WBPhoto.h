//
//  WBPhoto.h
//  whiteboard
//
//  Created by sad-fueled on 9/13/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUser.h"
#import <UIKit/UIKit.h>

@interface WBPhoto : NSObject

@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) WBUser *author;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSArray *likes; // contains users who liked.
@property (nonatomic, strong) NSArray *comments;

@end
