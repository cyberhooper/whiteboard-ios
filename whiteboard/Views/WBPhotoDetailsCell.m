//
//  WBPhotoDetailsCell.m
//  whiteboard
//
//  Created by prs-fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsCell.h"

@interface WBPhotoDetailsCell()
@property (nonatomic, strong) UIImageView *seperatorBottomImageView;
@end

@implementation WBPhotoDetailsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self setupView];
}

#pragma mark - Setup
- (void)setupView {
  // Defaults
  self.seperatorBottom = YES;
}

#pragma mark - Setters
- (void)setSeperatorBottom:(BOOL)seperatorBottom {
  _seperatorBottom = seperatorBottom;
  
  if(seperatorBottom){
    [self addSubview:self.seperatorBottomImageView];
  }else{
    [self.seperatorBottomImageView removeFromSuperview];
  }
}

#pragma mark - Getters
- (UIImageView *)seperatorBottomImageView {
  if(_seperatorBottomImageView != nil){
    return _seperatorBottomImageView;
  }
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  imageView.image = [[WBTheme sharedTheme] detailsCommentsSeperatorImage];
  imageView.contentMode = UIViewContentModeCenter;
  
  _seperatorBottomImageView = imageView;
  return _seperatorBottomImageView;
}

#pragma mark - Layout
- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Seperator bottom imageview frame
  CGFloat seperatorHeight = 2.f;
  CGFloat seperatorPosY = self.frame.size.height - 1.f;
  CGRect seperatorBottomFrame = CGRectMake(0.f,
                                           seperatorPosY,
                                           self.frame.size.width,
                                           seperatorHeight);
  self.seperatorBottomImageView.frame = seperatorBottomFrame;
  
  
}

#pragma mark - CellHeight
+ (CGFloat)cellHeight {
  
  [NSException raise:@"Implementation error" format:@"This method should be implemented in subclass"];
  
  return 0.f;
}

@end
