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
  [self.nameButton.titleLabel setFont:[[WBTheme sharedTheme] findFriendsNameFont]];
  [self.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
  [self.nameButton setTitleColor:[[WBTheme sharedTheme] findFriendsNameFontColor] forState:UIControlStateNormal];
  [self.nameButton setTitleColor:[[WBTheme sharedTheme] findFriendsNameFontColor] forState:UIControlStateHighlighted];
  [self.nameButton setTitleShadowColor:[[WBTheme sharedTheme] findFriendsNameShadowColor] forState:UIControlStateNormal];
  [self.nameButton setTitleShadowColor:[[WBTheme sharedTheme] findFriendsNameShadowColor] forState:UIControlStateSelected];
  [self.nameButton.titleLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
  [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpNumPhotosLabel {
  [self.numPhotosLabel setFont:[[WBTheme sharedTheme] findFriendsNumPhotosFont]];
  [self.numPhotosLabel setTextColor:[[WBTheme sharedTheme] findFriendsNumPhotosFontColor]];
  [self.numPhotosLabel setBackgroundColor:[UIColor clearColor]];
  [self.numPhotosLabel setShadowColor:[[WBTheme sharedTheme] findFriendsNumPhotosShadowColor]];
  [self.numPhotosLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
}

- (void)setUpFollowButton {
  [self.followButton.titleLabel setFont:[[WBTheme sharedTheme] findFriendsFollowButtonFont]];
  [self.followButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 10.0f, 0.0f, 0.0f)];
  [self.followButton setBackgroundImage:[[WBTheme sharedTheme] findFriendsFollowButtonNormalBackgroundImage] forState:UIControlStateNormal];
  [self.followButton setBackgroundImage:[[WBTheme sharedTheme] findFriendsFollowButtonSelectedBackgroundImage] forState:UIControlStateSelected];
  [self.followButton setImage:[[WBTheme sharedTheme] findFriendsFollowButtonSelectedImage] forState:UIControlStateSelected];
  [self.followButton setTitle:NSLocalizedString(@"FollowButton", @"Follow ") forState:UIControlStateNormal]; // space added for centering
  [self.followButton setTitle:NSLocalizedString(@"FollowingButton", @"Following") forState:UIControlStateSelected];
  [self.followButton setTitleColor:[[WBTheme sharedTheme] findFriendsFollowButtonNormalFontColor] forState:UIControlStateNormal];
  [self.followButton setTitleColor:[[WBTheme sharedTheme] findFriendsFollowButtonSelectedFontColor] forState:UIControlStateSelected];
  [self.followButton setTitleShadowColor:[[WBTheme sharedTheme] findFriendsFollowButtonNormalShadowColor] forState:UIControlStateNormal];
  [self.followButton setTitleShadowColor:[[WBTheme sharedTheme] findFriendsFollowButtonSelectedShadowColor] forState:UIControlStateSelected];
  [self.followButton.titleLabel setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
  [self.followButton setFrame:CGRectMake( 208.0f, 20.0f, 103.0f, 32.0f)];
  [self.followButton addTarget:self action:@selector(didTapFollowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setName:(NSString *)name {
  _name = name;
  
  CGSize maxSize = CGSizeMake(130, 30);
  CGRect nameSize = [name boundingRectWithSize:maxSize
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName : self.nameButton.titleLabel.font}
                                       context:nil];
  [self.nameButton setTitle:name forState:UIControlStateNormal];
  [self.nameButton setTitle:name forState:UIControlStateHighlighted];
  
  // Adding 10 to the width because of a potential bug in boundingRect
  [self.nameButton setFrame:CGRectMake( 60.0f, 17.0f, nameSize.size.width + 10, nameSize.size.height)];
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
