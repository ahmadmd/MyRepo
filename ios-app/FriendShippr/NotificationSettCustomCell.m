//
//  NotificationSettCustomCell.m
//  FriendShippr
//
//  Created by Zoondia on 30/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "NotificationSettCustomCell.h"

@implementation NotificationSettCustomCell

+ (NSString *)reuseIdentifier{
    return @"notifSettingsCellIdentifier";
}

- (IBAction)accessorySwitchValueChanged:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:FSNotifSettingSwitchValueChangedNotification object:self];
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
    [_notifSettIcon release];
    [_lblNotifSettName release];
    [_accessorySwitch release];
    [super dealloc];
}
@end
