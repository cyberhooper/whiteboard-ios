//
//  WBPhotoDetailsPhotoCell.h
//  whiteboard
//
//  Created by prs-fueled on 9/19/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBPhotoDetailsCell.h"

@interface WBPhotoDetailsCellPhoto : WBPhotoDetailsCell
/**
 The main photo to be displayed in the cell
 */
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@end
