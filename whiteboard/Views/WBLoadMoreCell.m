//
//  WBLoadMoreCell.m
//  whiteboard
//
//  Created by prs-fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBLoadMoreCell.h"

@interface WBLoadMoreCell()
@property (nonatomic, weak) IBOutlet UIImageView *seperatorTopImageView;
@property (nonatomic, weak) IBOutlet UIImageView *loadMoreImageView;
@end

@implementation WBLoadMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  if(self){
    [self setupView];
  }
  return self;
}

#pragma mark - Setup
- (void)setupView {

  
}

#pragma mark - Setters
- (void)setSeperatorTopImage:(UIImage *)seperatorTopImage {
  _seperatorTopImage = seperatorTopImage;
  
  // Set seperator image
  self.seperatorTopImageView.image = _seperatorTopImage;
}

- (void)setLoadMoreImage:(UIImage *)loadMoreImage {
  _loadMoreImage = loadMoreImage;
  
  // Set load more image
  self.loadMoreImageView.image = _loadMoreImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
