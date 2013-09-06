//
//  DeliveryDateCell.m
//  FriendShippr
//
//  Created by Zoondia on 25/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "DeliveryDateCell.h"

@implementation DeliveryDateCell


+ (NSString *)reuseIdentifier{
    return @"deliveryDateCellIdentifier";
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
    [_tickImageView release];
    [_lblHeadingText release];
    [_lblSubHeadingText release];
    [super dealloc];
}
@end
