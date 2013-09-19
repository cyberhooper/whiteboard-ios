//
//  WBProfileHeaderView.h
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBProfileHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberPicturesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowingLabel;

@end
