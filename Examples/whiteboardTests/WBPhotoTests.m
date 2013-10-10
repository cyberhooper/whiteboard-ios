//
//  WBPhotoTests.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/13/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBPhoto.h"
#import "WBUser.h"
#import "WBComment.h"

@interface WBPhotoTests : XCTestCase

@end

@implementation WBPhotoTests {
  WBPhoto *photo;
  WBUser *user;
  NSDate *date;
  NSURL *url;
  NSArray *comments;
}

- (void)setUp {
  [super setUp];
  user = [[WBUser alloc] init];
  date = [NSDate date];
  url = [NSURL URLWithString:@"http://www.google.com/avatar.png"];
  
  WBComment *comment1 = [[WBComment alloc] init];
  WBComment *comment2 = [[WBComment alloc] init];
  comments = @[comment1, comment2];
  
  photo = [[WBPhoto alloc] init];
  photo.photoID = @"14fgfq";
  photo.image = [UIImage imageNamed:@"photo"];
  photo.author = user;
  photo.createdAt = date;
  photo.url = url;
  photo.comments = comments;
}

- (void)tearDown {
  photo = nil;
  user = nil;
  date = nil;
  url = nil;
  comments = nil;
  [super tearDown];
}

- (void)testPhotoExists {
  XCTAssertNotNil(photo, @"Should be able to create a photo");
}

- (void)testPhotoHasAnID {
  XCTAssertEqualObjects(@"14fgfq", photo.photoID, @"Photo should have an ID");
}

- (void)testPhotoHasAnImage {
  XCTAssertEqualObjects([UIImage imageNamed:@"photo"], photo.image, @"should have an image");
}

- (void)testPhotoHAsAUser {
  XCTAssertEqualObjects(user, photo.author, @"Photo should have a user");
}

- (void)testPhotoHAsACreationDate {
  XCTAssertEqualObjects(date, photo.createdAt, @"Photo should have a creation date");
}

- (void)testPhotoHAsAURL {
  XCTAssertEqualObjects(url, photo.url, @"Photo should have a URL");
}

- (void)testPhotoHAsComments {
  XCTAssertEqualObjects(comments,photo.comments, @"Photo should have a comments");
}

@end
