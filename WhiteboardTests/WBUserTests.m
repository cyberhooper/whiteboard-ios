//
//  WBUserTests.m
//  Whiteboard
//
//  Created by Sacha Durand Saint Omer on 10/11/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBUser.h"

@interface WBUserTests : XCTestCase

@end

@implementation WBUserTests {
  WBUser *user;
}

- (void)setUp {
  [super setUp];
  user = [[WBUser alloc] init];
  user.userID = @"something34";
  user.displayName = @"My name";
  user.username = @"username";
  user.firstName = @"John";
  user.lastName = @"Smith";
  user.email = @"john.smith@gmail.com";
}

- (void)tearDown{
  user = nil;
  [super tearDown];
}

- (void)testUserExists {
  XCTAssertNotNil(user, @"We should be able to create a user");
}

- (void)testUserHasAUserID {
  XCTAssertEqualObjects(user.userID, @"something34", @"A User should have a userID");
}

- (void)testUserHasADisplayName {
  XCTAssertEqualObjects(user.displayName, @"My name", @"A User should have a display name");
}

- (void)testUserHasAUserName {
  XCTAssertEqualObjects(user.username, @"username", @"A User should have a username");
}

- (void)testUserHasAFirstName {
  XCTAssertEqualObjects(user.firstName , @"John", @"A User should have a firstName");
}

- (void)testUserHasALastName {
  XCTAssertEqualObjects(user.lastName , @"Smith", @"A User should have a lastName");
}

- (void)testUserHasAEmail {
  XCTAssertEqualObjects(user.email , @"john.smith@gmail.com", @"A User should have an email");
}

- (void)testUserHasAnAvatar {
  user.avatar = [NSURL URLWithString:@"http://www.foobar.jpg"];
  NSURL *url = [NSURL URLWithString:@"http://www.foobar.jpg"];
  XCTAssertEqualObjects(user.avatar , url, @"user should have an avatar");
}

- (void)testUserHasACreationDate {
  NSDate *date = [NSDate date];
  user.createdAt = date;
  XCTAssertEqualObjects(user.createdAt, date, @"User should have a creation date");
}

- (void)testUserHasAnUpdatedDate {
  NSDate *date = [NSDate date];
  user.updatedAt = date;
  XCTAssertEqualObjects(user.updatedAt, date, @"User should have a updated date");
}

- (void)testUserHasANumberOfFollowers {
  user.numberOfFollowers = @26;
  XCTAssertEqualObjects(user.numberOfFollowers, @26, @"User should have a number of followers");
}

- (void)testUserHasANumberFollowing {
  user.numberFollowing = @26;
  XCTAssertEqualObjects(user.numberFollowing, @26, @"User should have a number following");
}

- (void)testUserCanBeFollowed {
  user.isFollowed = YES;
  XCTAssertTrue(user.isFollowed, @"User should be able to be followed");
}

- (void)testUsersAreEqualIfTheyHaveTheSameID {
  WBUser *user2 = [[WBUser alloc] init];
  user2.userID = @"foo";
  XCTAssertNotEqualObjects(user, user2, @"Users with different IDs should not be equal");
  user2.userID = @"something34";
  XCTAssertEqualObjects(user, user2, @"Users with same IDs should be equal");
}

@end

