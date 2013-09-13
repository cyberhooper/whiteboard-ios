//
//  UserTests.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBUser.h"
#import "WBDataSource.h"

@interface UserTests : XCTestCase

@end

@implementation UserTests {
  WBUser *user;
}

- (void)setUp {
  [super setUp];
  user = [WBDataSource createUser];
}

- (void)tearDown{
  user = nil;
  [super tearDown];
}

- (void)testUserExists {
  XCTAssertNotNil(user, @"We should be able to create a user");
}

- (void)testUserHasAUserID {
  user.userID = @"something34";
  XCTAssertEqualObjects(user.userID, @"something34", @"A User should have a userID");
}

- (void)testUserHasADisplayName {
    user.displayName = @"My name";
  XCTAssertEqualObjects(user.displayName, @"My name", @"A User should have a display name");
}

- (void)testUserHasAUserName {
  user.username = @"username";
  XCTAssertEqualObjects(user.username, @"username", @"A User should have a username");
}

- (void)testUserHasAFirstName {
  user.firstName = @"John";
  XCTAssertEqualObjects(user.firstName , @"John", @"A User should have a firstName");
}

- (void)testUserHasALastName {
  user.lastName = @"Smith";
  XCTAssertEqualObjects(user.lastName , @"Smith", @"A User should have a lastName");
}

- (void)testUserHasAEmail {
  user.email = @"john.smith@gmail.com";
  XCTAssertEqualObjects(user.email , @"john.smith@gmail.com", @"A User should have an email");
}

- (void)testUserProfilePictureMediumURL {
  user.profilePictureMediumURL = [NSURL URLWithString:@"http://www.foobar.jpg"];
  NSURL *url = [NSURL URLWithString:@"http://www.foobar.jpg"];
  XCTAssertEqualObjects(user.profilePictureMediumURL , url, @"user should have a profilePictureMediumURL");
}

- (void)testUserProfilePictureSmallURL {
  user.profilePictureSmallURL = [NSURL URLWithString:@"http://www.foobar.jpg"];
  NSURL *url = [NSURL URLWithString:@"http://www.foobar.jpg"];
  XCTAssertEqualObjects(user.profilePictureSmallURL , url, @"user should have a profilePictureSmallURL");
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

//  numberFollowing : NSNumber
//  notificationSettings : NSDictionary
@end
