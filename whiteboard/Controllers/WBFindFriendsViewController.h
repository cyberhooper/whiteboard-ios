//
//  WBFindFriendsViewController.h
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBFriendCell.h"
#import "WBLoadMoreCell.h"
#import "WBInviteFriendsCell.h"

@interface WBFindFriendsViewController : UITableViewController <WBFriendCellDelegate>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic) BOOL loadMore;

/**
 Sets the name of the nib that is being used for the table cell
 */
- (NSString *)tableCellNib;

@end
