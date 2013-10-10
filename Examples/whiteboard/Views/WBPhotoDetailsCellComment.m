//
//  WBPhotoDetailsCellComment.m
//  whiteboard
//
//  Created by prs-fueled on 9/23/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBPhotoDetailsCellComment.h"
#import "UIImageView+RoundedCorners.h"
#import "FormatterKit/TTTTimeIntervalFormatter.h"

#define kMessageLabelWidth 220.f
#define kMessageLabelBottomPadding 60.f

@interface WBPhotoDetailsCellComment()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@end

@implementation WBPhotoDetailsCellComment

#pragma mark - Setup
- (void)setupView {
  [super setupView];
  
  // Avatar imageview
  [self.avatarImageView roundedCornersWithRadius:3.f];
  
  // Namelabel
  self.nameLabel.font = [[WBTheme sharedTheme] detailsCommentsNameFont];
  self.nameLabel.textColor = [[WBTheme sharedTheme] detailsCommentsNameFontColor];
  
  // Message label
  self.messageLabel.font = [[WBTheme sharedTheme] detailsCommentsMessageFont];
  self.messageLabel.textColor = [[WBTheme sharedTheme] detailsCommentsMessageFontColor];
  
  // Date label
  self.dateLabel.font = [[WBTheme sharedTheme] detailsCommentsDateFont];
  self.dateLabel.textColor = [[WBTheme sharedTheme] detailsCommentsDateFontColor];
}

#pragma mark - Setters
- (void)setName:(NSString *)name {
  _name = name;
  
  self.nameLabel.text = name;
}

- (void)setMessage:(NSString *)message {
  _message = message;
  
  self.messageLabel.text = message;
}

- (void)setCreatedAt:(NSDate *)createdAt {
  _createdAt = createdAt;
  
  TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
  self.dateLabel.text = [timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date]
                                                                      toDate:createdAt];
}

#pragma mark - CellHeight
+ (CGFloat)cellHeightWithMessage:(NSString *)message {
  NSAttributedString *attributedText = [[NSAttributedString alloc]
                                        initWithString:message
                                        attributes:@{
                                                     NSFontAttributeName: [[WBTheme sharedTheme] detailsCommentsMessageFont]
                                                     }];
  
  CGRect rect = [attributedText boundingRectWithSize:(CGSize){kMessageLabelWidth, CGFLOAT_MAX}
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
  return rect.size.height + kMessageLabelBottomPadding;
}

#pragma mark - Layout
- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Message label
  CGRect messageLabelFrame = CGRectMake(self.messageLabel.frame.origin.x,
                                        self.messageLabel.frame.origin.y,
                                        kMessageLabelWidth,
                                        self.messageLabel.frame.size.height);
  self.messageLabel.frame = messageLabelFrame;
  [self.messageLabel sizeToFit];
}

@end
