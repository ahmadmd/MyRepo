//
//  SettingsCustomCell.m
//  FriendShippr
//
//  Created by Zoondia on 29/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "SettingsCustomCell.h"

@implementation SettingsCustomCell

+ (NSString *)reuseIdentifier{
    return @"SettingsCellIdentifier";
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
    [_settingsIcon release];
    [_lblSettingsName release];
    [_accessoryImage release];
    [super dealloc];
}
@end
