//
//  WBDatasourceTests.m
//  whiteboard
//
//  Created by Sacha Durand Saint Omer on 9/10/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WBDataSource.h"

@interface WBDatasourceTests : XCTestCase

@end

@implementation WBDatasourceTests {
  WBDataSource *dataSource;
  __block BOOL hasCalledBack;
}

- (void)setUp {
  [super setUp];
  hasCalledBack = NO;
}

- (void)tearDown {
  dataSource = nil;
  NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
  while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                             beforeDate:loopUntil];
  }
  
  if (!hasCalledBack) {
    XCTFail(@"No response after 10 sec");
  }
  hasCalledBack = NO;
  [super tearDown];
}

#pragma mark - login

- (void)testLoginWithValidCredentialsCallsSuccess {
  [[WBDataSource sharedInstance] loginWithUsername:@"testUser" andPassWord:@"test" success:^(id<WBUser> user) {
    hasCalledBack = YES;
  } failure:nil];
}

- (void)testLoginWithValidCredentialsReturnsANonNilUser {
  [[WBDataSource sharedInstance] loginWithUsername:@"testUser" andPassWord:@"test" success:^(id<WBUser> user) {
    hasCalledBack = YES;
    XCTAssertNotNil(user, @"User return on login should not be nil");
  } failure:nil];
}

- (void)testLoginWithValidCredentialsReturnsAValidUser {
  [[WBDataSource sharedInstance] loginWithUsername:@"testUser" andPassWord:@"test" success:^(id<WBUser> user) {
    hasCalledBack = YES;
    XCTAssertEqualObjects(user.userName, @"testUser", @"User logged in should be the right one");
  } failure:nil];
}

- (void)testLoginWithInvalidCredentialsCallsFailure {
  [[WBDataSource sharedInstance] loginWithUsername:@"dgsgsd" andPassWord:@"dgsdgsd" success:nil failure:^(NSError *error) {
    hasCalledBack = YES;
  }];
}

- (void)testLoginWithInvalidCredentialsYieldsError {
  [[WBDataSource sharedInstance] loginWithUsername:@"dgsgsd" andPassWord:@"dgsdgsd" success:nil failure:^(NSError *error) {
    XCTAssertNotNil(error, @"Loging with invalid credentials should return an error");
    hasCalledBack = YES;
  }];
}

- (void)testLogoutUser {
  id<WBUser> currentUser = [WBDataSource sharedInstance].currentUser;
  XCTAssertNotNil([WBDataSource sharedInstance].currentUser, @"User should be logged out after logout");
  [[WBDataSource sharedInstance] logoutUser:currentUser success:^{
    hasCalledBack = YES;
    XCTAssertNil([WBDataSource sharedInstance].currentUser, @"User should be logged out after logout");
  }failure:nil];
}



@end
