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

@interface WBPhotoTests : XCTestCase

@end

@implementation WBPhotoTests {
  WBPhoto *photo;
  WBUser *user;
}

- (void)setUp {
  [super setUp];
  photo = [[WBPhoto alloc] init];
  photo.image = [UIImage imageNamed:@"photo"];
  photo.author = [[WBUser alloc] init];
}

- (void)tearDown {
  photo = nil;
  [super tearDown];
}

- (void)testPhotoExists {
  XCTAssertNotNil(photo, @"Should be able to create a photo");
}

- (void)testPhotoHasAnImage {
  XCTAssertEqualObjects([UIImage imageNamed:@"photo"], photo.image, @"should have an image");
}

- (void)testPhotoHAsAUser {
  XCTAssertEqualObjects(user, photo.author, @"Photo should have a user");
}

@end
