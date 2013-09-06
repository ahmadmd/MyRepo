//
//  MyFriendsCell.m
//  FriendShippr
//
//  Created by Zoondia on 13/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "MyFriendsCell.h"

@implementation MyFriendsCell

+ (NSString *)reuseIdentifier{
    return @"myFriendsCellIdentifier";
}

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

- (void)dealloc {
    [_friendProfileImage release];
    [_friendName release];
    [_friendAccesoryImage release];
    [super dealloc];
}
@end
