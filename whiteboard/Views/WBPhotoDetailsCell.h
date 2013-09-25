//
//  WBPhotoDetailsCell.h
//  whiteboard
//
//  Created by prs-fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPhotoDetailsCell : UITableViewCell

/**
 Adds or hides the seperator to the bottom of the cell
 */
@property (nonatomic, assign) BOOL seperatorBottom;

/**
 Sets up the view
 */
- (void)setupView;

/**
 Returns the height of the cell
 */
+ (CGFloat)cellHeight;

@end
