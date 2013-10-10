//
//  WBNavigationController.m
//  whiteboard
//
//  Created by lnf-fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBNavigationController.h"
#import "Whiteboard.h"
#import "WBPhotoTimelineViewController.h"
#import "ProfileViewController.h"
#import "WBFindFriendsViewController.h"

@interface WBNavigationController ()

@end

@implementation WBNavigationController

static const int kMyProfileIndex = 0;
static const int kFindFriendsIndex = 1;
static const int kLogOutIndex = 2;


- (void)viewDidLoad {
  [super viewDidLoad];
  self.showSettingsButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setUpView];
}

- (void)setUpView {
  // Set background image
  [self.navigationBar setBackgroundImage:[[WBTheme sharedTheme] navBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
  
  // Add title
  self.topViewController.navigationItem.title = NSLocalizedString(@"NavBarTitle", @"Whiteboard");
  
  // Set font and color
  [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [[WBTheme sharedTheme] navBarTitleFontColor], NSFontAttributeName : [[WBTheme sharedTheme] navBarTitleFont]}];
  if ([self showSettingsButton]) {
    [self setUpSettingsButton];
  }
}

- (void)showSettingsButton:(BOOL)value {
  _showSettingsButton = value;
}

- (void)setUpSettingsButton {
  // Create right bar button (Settings)
  UIImage *settingsButtonBackgroundImage = [[WBTheme sharedTheme] navBarSettingsButtonBackgroundImage];
  
  UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
  settingsButton.frame = CGRectMake( 0, 0, settingsButtonBackgroundImage.size.width, settingsButtonBackgroundImage.size.height );
  [settingsButton setBackgroundImage:settingsButtonBackgroundImage forState:UIControlStateNormal];
  [settingsButton setImage:[[WBTheme sharedTheme] navBarSettingsButtonImage] forState:UIControlStateNormal];
  [settingsButton setImage:[[WBTheme sharedTheme] navBarSettingsButtonHighlightedImage] forState:UIControlStateHighlighted];
  
  [settingsButton addTarget:self action:@selector(settingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  
  UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
  self.topViewController.navigationItem.rightBarButtonItem = settingsBarButtonItem;

}

- (void)settingsButtonPressed {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"MyProfile", @"My Profile"), NSLocalizedString(@"FindFriends", @"Find Friends"), NSLocalizedString(@"LogOut", @"Log Out"), nil];
  [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case kMyProfileIndex: {
      ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:NSStringFromClass([ProfileViewController class])
                                                                                             bundle:nil];
      
      
      [profileViewController setUser:[WBDataSource currentUser]];
      [self pushViewController:profileViewController animated:YES];

      UIImage *settingsButtonBackgroundImage = [[WBTheme sharedTheme] navBarSettingsButtonBackgroundImage];

      UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
      settingsButton.frame = CGRectMake( 0, 0, settingsButtonBackgroundImage.size.width, settingsButtonBackgroundImage.size.height );
      [settingsButton setBackgroundImage:settingsButtonBackgroundImage forState:UIControlStateNormal];
      [settingsButton setImage:[[WBTheme sharedTheme] navBarSettingsButtonImage] forState:UIControlStateNormal];
      [settingsButton setImage:[[WBTheme sharedTheme] navBarSettingsButtonHighlightedImage] forState:UIControlStateHighlighted];
      
      [settingsButton addTarget:self action:@selector(settingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
      
      UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
      self.topViewController.navigationItem.rightBarButtonItem = settingsBarButtonItem;

      break;
    }
    case kFindFriendsIndex: {
      WBFindFriendsViewController *findFriendsViewController = [[WBFindFriendsViewController alloc] init];
      [self pushViewController:findFriendsViewController animated:YES];
      break;
    }
    case kLogOutIndex: {
      [[WBAccountManager sharedInstance] logoutUser:[WBDataSource currentUser] success:^{
        if ([self.visibleViewController isKindOfClass:[WBPhotoTimelineViewController class]] &&
            [self.visibleViewController respondsToSelector:@selector(showLoginScreen)]) {
          [(WBPhotoTimelineViewController *)self.visibleViewController showLoginScreen];
        }
      } failure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LogOutFailed", "Log Out Failed")
                                                        message:NSLocalizedString(@"LogOutFailedMessage", @"Log out failed...")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                              otherButtonTitles:nil];
        [alert show];
      }];
      break;
    }
    default:
      break;
  }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
