//
//  WBActivityCell.m
//  whiteboard
//
//  Created by ttg-fueled on 9/20/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBActivityCell.h"
#import "TTTTimeIntervalFormatter.h"

static TTTTimeIntervalFormatter *timeFormatter;

@implementation WBActivityCell

- (IBAction)pictureTouch {
  [self.delegate fromUserProfilePressed:self];
}

- (IBAction)nameTouch:(id)sender {
  [self.delegate fromUserProfilePressed:self];
}


- (void)setDate:(NSDate *)date {
  if (!timeFormatter) {
    timeFormatter = [[TTTTimeIntervalFormatter alloc]init];
  }
  [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date]
                                                                toDate:date]];
}

@end
