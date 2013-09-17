//
//  EmailValidator.m
//  whiteboard
//
//  Created by sad-fueled on 7/1/13.
//  Copyright (c) 2013 Fueled Inc. All rights reserved.
//

#import "EmailValidator.h"

// This is a Regex to validate the email field

// RFC 2822 adaptation of emailAddress regular expression for Obj-C
// inspired from :http://www.cocoawithlove.com/2009/06/verifying-that-string-is-email-address.html
NSString *const emailRegex =
@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

@implementation EmailValidator

// we return YES if the string matches the email regex, else we return NO.
- (BOOL)isValid:(NSString *)string {
  NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [p evaluateWithObject:string];
}

@end
