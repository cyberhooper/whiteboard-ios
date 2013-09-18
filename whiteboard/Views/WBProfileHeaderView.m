//
//  WBProfileHeaderView.m
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/17/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBProfileHeaderView.h"

@implementation WBProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      [self setUpView];
    }
    return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self setUpView];
}

#pragma mark - Setup

- (void)setUpView {
  
}

@end
