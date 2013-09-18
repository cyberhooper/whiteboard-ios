//
//  WBFriendCell.m
//  whiteboard
//
//  Created by Lauren Frazier | Fueled on 9/18/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBFriendCell.h"

@interface WBFriendCell()

@property (nonatomic, weak) IBOutlet UILabel *numPhotosLabel;
@property (nonatomic, weak) IBOutlet UIButton *followButton;
@property (nonatomic, weak) IBOutlet UIButton *nameButton;
@property (nonatomic, weak) IBOutlet UIButton *avatarImageButton;

@end

@implementation WBFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self setUpView];
    }
    return self;
}

-(void)awakeFromNib {
  [self setUpView];
}

- (void)setUpView {
  self.contentView.backgroundColor = [UIColor colorWithPatternImage:[[WBTheme sharedTheme] findFriendsCellBackgroundImage]];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  [self setUpAvatar];
  [self setUpNameButton];
  [self setUpNumPhotosLabel];
  [self setUpFollowButton];
}

- (void)setUpAvatar {
  // Set up the image view
  [self.avatarImageView setFrame:CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f)];
  [self.avatarImageView roundedCornersWithRadius:5.0f];
  self.avatarImageView.backgroundColor = [UIColor blueColor];
  // Set up the invisible button
  [self.avatarImageButton setBackgroundColor:[UIColor clearColor]];
  [self.avatarImageButton setFrame:CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f)];
  [self.avatarImageButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpNameButton {
  [self.nameButton setBackgroundColor:[UIColor clearColor]];
  [self.nameButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
  [self.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
  [self.nameButton setTitleColor:[UIColor colorWithRed:87.0f/255.0f green:72.0f/255.0f blue:49.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
  [self.nameButton setTitleColor:[UIColor colorWithRed:134.0f/255.0f green:100.0f/255.0f blue:65.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
  [self.nameButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.nameButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
  [self.nameButton.titleLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
  [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpNumPhotosLabel {
  
}

- (void)setUpFollowButton {
  
}

+ (CGFloat)heightForCell {
  return 67.0f;
}

#pragma mark Delegate Callbacks
- (void)didTapUserButtonAction:(id)sender {
//  if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
//    [self.delegate cell:self didTapUserButton:self.user];
//  }
  NSLog(@"User button tapped");
}

- (void)didTapFollowButtonAction:(id)sender {
//  if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapFollowButton:)]) {
//    [self.delegate cell:self didTapFollowButton:self.user];
//  }
  NSLog(@"Follow button tapped");
}


@end
