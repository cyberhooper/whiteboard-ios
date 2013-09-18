//
//  WBLoadMoreCell.h
//  whiteboard
//
//  Created by prs-fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBLoadMoreCell : UITableViewCell

/**
 The image to be used for the top seperator
 */
@property (nonatomic, strong) UIImage *seperatorTopImage;

/**
 The load more image to be displayed in the cell
 */
@property (nonatomic, strong) UIImage *loadMoreImage;

@end
