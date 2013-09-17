//
//  EmailValidator.h
//  whiteboard
//
//  Created by sad-fueled on 7/1/13.
//  Copyright (c) 2013 Fueled Inc. All rights reserved.
//


// Input validator that checks to see if a field contains a valid email address.
@interface EmailValidator : NSObject 

- (BOOL)isValid:(NSString *)string;

@end
