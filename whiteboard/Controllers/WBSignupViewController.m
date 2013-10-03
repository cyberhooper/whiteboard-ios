//
//  WBSignupViewController.m
//  whiteboard
//
//  Created by ttg-fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBSignupViewController.h"
#import "WBDataSource.h"
#import "WBAccountManager.h"
#import "EmailValidator.h"
#import "KeyboardAnimationView.h"

@interface WBSignupViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation WBSignupViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.userNameTextField setDelegate:self];
  [self.emailTextField setDelegate:self];
  [self.passwordTextField setDelegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.userNameTextField) {
    if (!(self.userNameTextField.text.length > 0)) {
      [self.userNameTextField setBackgroundColor:[UIColor redColor]];
    }
    [self.emailTextField becomeFirstResponder];
  }
  else if (textField == self.emailTextField) {
    EmailValidator *validator = [[EmailValidator alloc]init];
    if (![validator isValid:self.emailTextField.text]) {
      [self.emailTextField setBackgroundColor:[UIColor redColor]];
    }
    [self.passwordTextField becomeFirstResponder];
  }
  else {
    if (!(self.passwordTextField.text.length >= 6)) {
      [self.passwordTextField setBackgroundColor:[UIColor redColor]];
    }
    [self.view endEditing:YES];
  }
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [textField setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)loginAction:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signupAction:(id)sender {
  EmailValidator *validator = [[EmailValidator alloc]init];
  if (self.userNameTextField.text.length > 0 &&
      self.passwordTextField.text.length >= 6 &&
      [validator isValid:self.emailTextField.text]) {
    
    NSDictionary *usersInfos = [[NSDictionary alloc]initWithObjects:@[self.userNameTextField.text,
                                                                      self.emailTextField.text,
                                                                      self.passwordTextField.text]
                                                            forKeys:@[@"userName",
                                                                      @"email",
                                                                      @"password"]];
    [[WBAccountManager sharedInstance] signupWithInfo:usersInfos success:^(WBUser *user) {
      [self.navigationController dismissViewControllerAnimated:YES
                                                    completion:nil];
    } failure:^(NSError *error) {
      [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", @"Error")
                                 message:NSLocalizedString(@"try later", @"try later")
                                delegate:nil
                       cancelButtonTitle:nil
                       otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"), nil]show];
    }];
  }
  else {
    [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Wrong creditentials", @"Wrong creditentials")
                               message:NSLocalizedString(@"username not empty, email valid and 6 characters for the password", @"username not empty, email valid and 6 characters for the password")
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"), nil]show];
  }
}

@end
