//
//  UserJoinedCell.m
//  FriendShippr
//
//  Created by Zoondia on 24/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "UserJoinedCell.h"

@implementation UserJoinedCell


+ (NSString *)reuseIdentifier{
    return @"userJoinedCellIdentifier";
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
    [_lblUserName release];
    [_lblTimeDisplay release];
    [super dealloc];
}
@end
