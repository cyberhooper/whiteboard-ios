//
//  WBActivityTests.m
//  Whiteboard
//
//  Created by Sacha Durand Saint Omer on 10/11/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBActivity.h"

@interface WBActivityTests : XCTestCase

@end

@implementation WBActivityTests {
  WBActivity *activity;
  WBUser *user;
  WBPhoto *photo;
  NSDate *date;
}

- (void)setUp {
  [super setUp];
  photo = [[WBPhoto alloc] init];
  date = [NSDate date];
  
  activity = [[WBActivity alloc] init];
  activity.type = @"like";
  activity.photo = photo;
  activity.createdAt = date;
}

- (void)tearDown {
  activity = nil;
  user = nil;
  photo = nil;
  date = nil;
  [super tearDown];
}

- (void)testActivityExists {
  XCTAssertNotNil(activity, @"Should be able to create an activity");
}

- (void)testActivityHasAType {
  XCTAssertEqualObjects(activity.type, @"like", @"Activity should have a type");
}

- (void)testActivityHasAPhoto {
  XCTAssertEqualObjects(photo, activity.photo, @"Activity should have a photo");
}

- (void)testActivityHasACreationDate {
  XCTAssertEqualObjects(date, activity.createdAt, @"Activity should have a creation date");
}

@end
