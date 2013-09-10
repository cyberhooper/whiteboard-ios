//
//  WBDataSource.h
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/10/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUser.h"

@interface WBDataSource : NSObject

+ (id)sharedInstance;

- (void)loginWithUsername:(NSString *)username
              andPassWord:(NSString *)password
                  success:(void(^)(id<WBUser> user))success
                  failure:(void(^)(NSError *error))failure;

+ (void)initWithDataSourceSubclass:(Class)dataSourceSubclass;

@end
