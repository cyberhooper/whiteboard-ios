//
//  WBPhotoDetailsCellLikes.h
//  whiteboard
//
//  Created by prs-fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsCell.h"

@protocol WBPhotoDetailsCellLikesDelegate <NSObject>

- (void)likesCellDidSelectAvatarAtIndex:(NSUInteger)index;

@end

@interface WBPhotoDetailsCellLikes : WBPhotoDetailsCell

/**
 Sets if the photo is liked or not
 */
@property (nonatomic, assign) BOOL isLiked;

/**
 An array full of WBUser's who has liked the photo
 */
@property (nonatomic, assign) NSArray *likers;

@property (nonatomic, weak) id<WBPhotoDetailsCellLikesDelegate> delegate;

@end
