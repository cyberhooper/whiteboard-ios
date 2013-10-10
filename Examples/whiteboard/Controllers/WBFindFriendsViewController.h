//
//  WBFindFriendsViewController.h
//  whiteboard
//
//  Created by lnf-fueled on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "WBFriendCell.h"
#import "WBLoadMoreCell.h"
#import "WBInviteFriendsCell.h"


@interface WBFindFriendsViewController : UITableViewController <WBFriendCellDelegate, ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic) BOOL loadMore;
@property (nonatomic, strong) UIBarButtonItem *followAllButton;
@property (nonatomic, strong) UIBarButtonItem *unfollowAllButton;

/**
 Sets the name of the nib that is being used for the table cell
 */
- (NSString *)tableCellNib;

@end
