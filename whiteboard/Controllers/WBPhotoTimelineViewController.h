//
//  WBPhotoTimelineViewController.h
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBViewController.h"

@interface WBPhotoTimelineViewController : WBViewController <UITableViewDataSource,
                                                             UITableViewDelegate>

/**
 The main tableview that is being used for the photo timeline
 */
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/**
 This array contains the Photo objects to be displayed in the
 */
@property (nonatomic, strong) NSArray *photos;

/**
 Sets and returns the value if the table is loading or not
 */
@property (nonatomic, assign) BOOL isLoading;

/**
 Sets the name of the nib that is being used for the table cell
 */
- (NSString *)tableCellNib;

@end
