//
//  WBComment.h
//  whiteboard
//
//  Created by sad-fueled on 9/16/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUser.h"

@interface WBComment : NSObject

@property (nonatomic, strong) NSString *commentID;
@property (nonatomic, strong) WBUser *author;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;

@end
