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

- (void)layoutSubviews {
  [super layoutSubviews];

  // Layout the name button
  CGSize nameSize = [self.nameButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:13]
                                                                                                    forKey:NSFontAttributeName]];
  [self.nameButton setFrame:CGRectMake(46.0,
                                       8.0,
                                       nameSize.width,
                                       nameSize.height)];
  
  // Layout the content
  CGSize contentSize = [self.contentLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13]
                                                                                              forKey:NSFontAttributeName]];
  [self.contentLabel setFrame:CGRectMake(46.0,
                                         10.0,
                                         contentSize.width,
                                         contentSize.height)];
  
  // Layout the timestamp label
  CGSize timeSize = [self.timeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:11]
                                                                                        forKey:NSFontAttributeName]];
  [self.timeLabel setFrame:CGRectMake(46,
                                      self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height,
                                      timeSize.width,
                                      timeSize.height)];
  
}

- (void)setDate:(NSDate *)date {
  // Set the label with a human readable time
  [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:date]];
  [self setNeedsDisplay];
}

@end
