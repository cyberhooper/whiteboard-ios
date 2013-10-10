//
//  WBPhotoDetailsViewController.h
//  whiteboard
//
//  Created by prs-fueled on 9/19/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBViewController.h"
#import <WBFramework/WBFramework.h>

@interface WBPhotoDetailsViewController : WBViewController

/**
 The photo to be displayed in the view controller
 */
@property (nonatomic, strong) WBPhoto *photo;

@end
