//
//  WBPhotoDetailsCellAddComment.h
//  whiteboard
//
//  Created by prs-fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsCell.h"

@class WBPhotoDetailsCellAddComment;

@protocol WBPhotoDetailsCellAddCommentDelegate <NSObject>

- (void)commentCell:(WBPhotoDetailsCellAddComment *)cell didTapSendWithText:(NSString *)text;

@end

@interface WBPhotoDetailsCellAddComment : WBPhotoDetailsCell

@property (nonatomic, weak) id<WBPhotoDetailsCellAddCommentDelegate> delegate;
- (void)clearTextField;

@end
