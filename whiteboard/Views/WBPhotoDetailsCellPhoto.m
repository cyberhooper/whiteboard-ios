//
//  WBPhotoDetailsPhotoCell.m
//  whiteboard
//
//  Created by prs-fueled on 9/19/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsCellPhoto.h"


@interface WBPhotoDetailsCellPhoto()
@end

@implementation WBPhotoDetailsCellPhoto

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self){

  }
  return self;
}

#pragma mark - SetupView
- (void)setupView {
  [super setupView];
  
  // Defaults
  self.seperatorBottom = NO;
}

#pragma mark - CellHeight
+ (CGFloat)cellHeight {
  return 280.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
