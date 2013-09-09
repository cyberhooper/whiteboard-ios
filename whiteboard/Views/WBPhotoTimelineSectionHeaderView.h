//
//  WBPhotoTimelineSectionHeaderView.h
//  whiteboard
//
//  Created by prs-fueled on 9/9/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPhotoTimelineSectionHeaderView : UIView

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) UIImage *profilePictureImage;

@end
