//
//  WBLoginViewController.m
//  whiteboard
//
//  Created by Thibault Gauche on 9/16/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBLoginViewController.h"
#import "WBAccountManager.h"
#import "WBSignupViewController.h"

@interface WBLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *validationButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *loginWithFacebookButton;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation WBLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.usernameTextField setDelegate:self];
  [self.passwordTextField setDelegate:self];
  
  [self setupView];
}

- (void)setupView {
  [self.loginWithFacebookButton setBackgroundImage:[[WBTheme sharedTheme] loginLoginWithFacebookImage] forState:UIControlStateNormal];
  [self.loginWithFacebookButton setBackgroundImage:[[WBTheme sharedTheme] loginLoginWithFacebookSelectedImage] forState:UIControlStateHighlighted];
  self.backgroundImageView.image =[[WBTheme sharedTheme] loginBackgroundImage];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.usernameTextField) {
    [self.passwordTextField becomeFirstResponder];
  }
  else {
    [self.view endEditing:YES];
    [self loginUser];
  }
  return YES;
}

- (IBAction)validFieldsAction:(id)sender {
  [self loginUser];
}

- (void)loginUser {
  [[WBAccountManager sharedInstance]loginWithUsername:self.usernameTextField.text
                                      andPassWord:self.passwordTextField.text
                                          success:^(WBUser *user) {
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                          } failure:^(NSError *error) {
                                            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Wrong creditentials", @"Wrong creditentials")
                                                                       message:NSLocalizedString(@"Please try again", @"Please try again")
                                                                      delegate:nil
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"), nil]show ];
                                          }];
}
- (IBAction)loginWithFacebookAction:(id)sender {
    [[WBAccountManager sharedInstance]loginWithFacebook:^{
      [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
      [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Wrong creditentials", @"Wrong creditentials")
                                 message:NSLocalizedString(@"Please try again", @"Please try again")
                                delegate:nil
                       cancelButtonTitle:nil
                       otherButtonTitles:NSLocalizedString(@"Ok", @"Ok"), nil]show ];
    }];
}

- (IBAction)registerAction:(id)sender {
  WBSignupViewController *signupVC = [[WBSignupViewController alloc]init];
  [self.navigationController pushViewController:signupVC animated:YES];
  
}

@end
