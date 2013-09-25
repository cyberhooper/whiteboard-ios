//
//  WBActivityCell.m
//  whiteboard
//
//  Created by Thibault Gauche on 9/20/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBActivityCell.h"
#import "TTTTimeIntervalFormatter.h"

static TTTTimeIntervalFormatter *timeFormatter;

@implementation WBActivityCell

- (void)setUpCell {
  
  [self.nameButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
  [self.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
  
  CGSize nameSize = [self.nameButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}];
  
  [self.nameButton setFrame:CGRectMake(46.0,
                                       8.0,
                                       nameSize.width,
                                       nameSize.height)];
  // Layout the content
  CGSize contentSize = [self.contentLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
  [self.contentLabel setFrame:CGRectMake(nameSize.width,
                                         8.0,
                                         contentSize.width,
                                         contentSize.height)];
  // Layout the timestamp label
  CGSize timeSize = [self.timeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}];
  [self.timeLabel setFrame:CGRectMake(46,
                                      self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height,
                                      timeSize.width,
                                      timeSize.height)];
  [self setNeedsDisplay];

}

- (void)setDate:(NSDate *)date {
  if (!timeFormatter) {
    timeFormatter = [[TTTTimeIntervalFormatter alloc]init];
  }
  [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date]
                                                                toDate:date]];
}

@end
