//
//  WBPhotoDetailsCellComment.h
//  whiteboard
//
//  Created by prs-fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsCell.h"

@interface WBPhotoDetailsCellComment : WBPhotoDetailsCell

/**
 The avatar imageview of the user that has created the comment
 */
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

/**
 Sets the name of the user who created the comment
 */
@property (nonatomic, copy) NSString *name;

/**
 Sets the message of the comment
 */
@property (nonatomic, copy) NSString *message;

/**
 Sets the date when the comment was created
 */
@property (nonatomic, strong) NSDate *createdAt;

/**
 Height for the cell with given message string
 */
+ (CGFloat)cellHeightWithMessage:(NSString *)message;

@end
