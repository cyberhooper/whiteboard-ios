//
//  WBActivityCell.h
//  whiteboard
//
//  Created by ttg-fueled on 9/20/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBActivityCell;

@protocol WBActivitycellDelegate <NSObject>
@required
- (void)fromUserProfilePressed:(WBActivityCell *)cell;

@end

@interface WBActivityCell : UITableViewCell

@property (weak, nonatomic) id<WBActivitycellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shadowAvatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

- (void)setDate:(NSDate *)date;

@end
