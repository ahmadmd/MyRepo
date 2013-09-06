//
//  ShipRequestConfirmOrdinaryCell.m
//  FriendShippr
//
//  Created by Zoondia on 29/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "ShipRequestConfirmOrdinaryCell.h"

@implementation ShipRequestConfirmOrdinaryCell


+ (NSString *)reuseIdentifier{
    return @"ShipRequestConfirmOrdinaryCellIdentifier";
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
    [_lblName release];
    [_imageHolder release];
    [super dealloc];
}
@end
