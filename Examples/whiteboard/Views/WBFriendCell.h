//
//  WBFriendCell.h
//  whiteboard
//
//  Created by lnf-fueled on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+RoundedCorners.h"
#import "Whiteboard.h"

@protocol WBFriendCellDelegate;

@interface WBFriendCell : UITableViewCell

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *numPhotos;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIButton *followButton;
@property (nonatomic, strong) NSNumber *userIndex;
@property (nonatomic, weak) id<WBFriendCellDelegate> delegate;

+ (CGFloat)heightForCell;

@end


@protocol WBFriendCellDelegate <NSObject>
/**
 Sent to the delegate when a user button is tapped
 */
- (void)cell:(WBFriendCell *)cellView didTapUserButtonAtIndex:(NSNumber *)userIndex;
- (void)cell:(WBFriendCell *)cellView didTapFollowButtonAtIndex:(NSNumber *)userIndex;

@end