//
//  WBActivity.h
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/24/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUser.h"
#import "WBPhoto.h"

@interface WBActivity : NSObject

@property (nonatomic, strong) WBUser *fromUser;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) WBPhoto *photo;

@end
