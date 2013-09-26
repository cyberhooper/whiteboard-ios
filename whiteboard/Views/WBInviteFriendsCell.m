//
//  WBInviteFriendsCell.m
//  whiteboard
//
//  Created by lnf-fueled on 9/19/13.
//  Copyright (c) 2013 Fueled. All rights reserved.
//

#import "WBInviteFriendsCell.h"

@implementation WBInviteFriendsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      [self setUpView];
    }
    return self;
}

- (void)awakeFromNib {
  [self setUpView];
}

- (void)setUpView {
  self.backgroundColor = [UIColor colorWithPatternImage:[[WBTheme sharedTheme] findFriendsCellBackgroundImage]];
  self.inviteFriendsLabel.font = [[WBTheme sharedTheme] findFriendsInviteFriendsFont];
  self.inviteFriendsLabel.textColor = [[WBTheme sharedTheme] findFriendsInviteFriendsFontColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
