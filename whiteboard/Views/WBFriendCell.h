//
//  WBFriendCell.h
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+RoundedCorners.h"

@interface WBFriendCell : UITableViewCell

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *numPhotos;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIButton *followButton;

+ (CGFloat)heightForCell;

@end
