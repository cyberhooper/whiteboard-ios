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
//  NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
//  while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
//    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
//                             beforeDate:loopUntil];
//  }
//  
//  if (!hasCalledBack) {
//    XCTFail(@"No response after 10 sec");
//  }
//  hasCalledBack = NO;
//  [super tearDown];
}

#pragma mark - login

- (void)testLoginWithValidCredentialsCallsSuccess {
  [[WBDataSource sharedInstance] loginWithUsername:@"testUser" andPassWord:@"test" success:^(WBUser *user) {
    hasCalledBack = YES;
  } failure:nil];
}

- (void)testLoginWithValidCredentialsReturnsANonNilUser {
  [[WBDataSource sharedInstance] loginWithUsername:@"testUser" andPassWord:@"test" success:^(WBUser *user) {
    hasCalledBack = YES;
    XCTAssertNotNil(user, @"User return on login should not be nil");
  } failure:nil];
}

- (void)testLoginWithValidCredentialsReturnsAValidUser {
  [[WBDataSource sharedInstance] loginWithUsername:@"testUser" andPassWord:@"test" success:^(WBUser *user) {
    hasCalledBack = YES;
    XCTAssertEqualObjects(user.username, @"testUser", @"User logged in should be the right one");
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

- (void)testSignUpWithValidCredentialsCallsSuccess {
  NSDictionary *userInfos = [[NSDictionary alloc] initWithObjects:@[@"testUser9", @"test"] forKeys:@[@"userName", @"password"]];
  [[WBDataSource sharedInstance] signupWithInfo:userInfos success:^(WBUser *user) {
    XCTAssertNotNil(user, @"User return on signup should not be nil");
    //We have to remove the user after the test to valid the next test launch
    [[WBDataSource sharedInstance] deleteUserAccount:user success:^{
      hasCalledBack = YES;
    } failure:^(NSError *error) {
    }];
  } failure:nil];
}

- (void)testSignupWithValidCredentialsReturnsAValidUser {
  NSDictionary *userInfos = [[NSDictionary alloc] initWithObjects:@[@"testUser0", @"test"] forKeys:@[@"userName", @"password"]];
  [[WBDataSource sharedInstance] signupWithInfo:userInfos success:^(WBUser *user) {
    XCTAssertEqualObjects(user.username, @"testUser0", @"User logged in should be the right one");
    
    //We have to remove the user after the test to valid the next test launch
    [[WBDataSource sharedInstance] deleteUserAccount:user success:^{
      hasCalledBack = YES;
    } failure:^(NSError *error) {
    }];
  } failure:nil];
}

- (void)testSignupWithInvalidCredentialsYieldsError {
  NSDictionary *userInfos = [[NSDictionary alloc] initWithObjects:@[@"testUser", @""] forKeys:@[@"userName", @"password"]];
  [[WBDataSource sharedInstance] signupWithInfo:userInfos success:^(WBUser *user) {
  } failure:^(NSError *error) {
    XCTAssertNotNil(error, @"signup with invalid credentials should return an error");
    hasCalledBack = YES;
  }];
}

- (void)testSignupWithInvalidCredentialsCallsFailure {
  NSDictionary *userInfos = [[NSDictionary alloc] initWithObjects:@[@"testUser", @""] forKeys:@[@"userName", @"password"]];
  [[WBDataSource sharedInstance] signupWithInfo:userInfos success:^(WBUser *user) {
  } failure:^(NSError *error) {
    hasCalledBack = YES;
  }];
}

- (void)testResetPasswordWithValidCredentials {
  WBUser *user = [WBDataSource createUser];
  [user setEmail:@"sacha@fueled.com"];
  [[WBDataSource sharedInstance] resetPasswordForUser:user success:^{
    hasCalledBack = YES;
  } failure:nil];
}

- (void)testResetPasswordWithInvalidCredentials {
  WBUser *user = [WBDataSource createUser];
  [user setEmail:@"fakemail@fueled.com"];
  [[WBDataSource sharedInstance] resetPasswordForUser:user success:^{
  } failure:^(NSError *error) {
    XCTAssertNotNil(error, @"signup with invalid credentials should return an error");
    hasCalledBack = YES;
  }];
}

- (void)testEditAccountSucceeds {
  __block BOOL successCalled = NO;
  WBUser *user = [WBDataSource createUser];
  [[WBDataSource sharedInstance] saveUser:user success:^{
    hasCalledBack = YES;
    successCalled = YES;
  } failure:^(NSError *error) {
    
  }];
  
  XCTAssertTrue(successCalled, @"fsf");
}

- (void)testEditAccountFailsWithWrongUser {
  [[WBDataSource sharedInstance] saveUser:nil
                                  success:nil
                                  failure:^(NSError *error) {
    hasCalledBack = YES;
  }];
}

- (void)testLogoutUser {
  WBUser *currentUser = [[WBDataSource sharedInstance] currentUser];
  XCTAssertNotNil([WBDataSource sharedInstance].currentUser, @"User should be logged out after logout");
  [[WBDataSource sharedInstance] logoutUser:currentUser success:^{
    hasCalledBack = YES;
    XCTAssertNil([WBDataSource sharedInstance].currentUser, @"User should be logged out after logout");
  }failure:nil];
}

@end
