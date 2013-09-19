//
//  WBPhotoDetailsPhotoCell.m
//  whiteboard
//
//  Created by prs-fueled on 9/19/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsPhotoCell.h"

@interface WBPhotoDetailsPhotoCell()
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@end

@implementation WBPhotoDetailsPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
