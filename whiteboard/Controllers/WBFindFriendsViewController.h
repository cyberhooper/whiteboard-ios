//
//  WBFindFriendsViewController.h
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBFindFriendsViewController : UITableViewController

@property (nonatomic, strong) NSArray *users;

/**
 Sets the name of the nib that is being used for the table cell
 */
- (NSString *)tableCellNib;

@end
