//
//  WBCommentTests.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/16/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBComment.h"
#import "WBUser.h"

@interface WBCommentTests : XCTestCase

@end

@implementation WBCommentTests {
  WBComment *comment;
  WBUser *user;
  NSDate *date;
}

- (void)setUp {
  [super setUp];
  user = [[WBUser alloc] init];
  date = [NSDate date];
  comment = [[WBComment alloc] init];
  comment.commentID = @"blabli42toto";
  comment.author = user;
  comment.createdAt = date;
  comment.text = @"Super idée !";
}

- (void)tearDown {
  comment = nil;
  user = nil;
  date = nil;
  [super tearDown];
}

- (void)testCommentExists {
  XCTAssertNotNil(comment, @"Should be able to create a comment");
}

- (void)testCommentHAsAnID {
  XCTAssertEqualObjects(@"blabli42toto", comment.commentID, @"Comment should have an ID");
}

- (void)testCommentHasAnAuthor {
  XCTAssertEqualObjects(user, comment.author, @"Comment should have an author");
}

- (void)testCommentHAsACreationDate {
  XCTAssertEqualObjects(date, comment.createdAt, @"Comment should have a creation date");
}
- (void)testCommentHAsAText {
  XCTAssertEqualObjects(@"Super idée !", comment.text, @"Comment should have a text");
}

@end
