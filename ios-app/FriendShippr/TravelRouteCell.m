//
//  TravelRouteCell.m
//  FriendShippr
//
//  Created by Zoondia on 27/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "TravelRouteCell.h"

@implementation TravelRouteCell

+ (NSString *)reuseIdentifier{
    return @"travelRouteReuseIdentifier";
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
    [_lblTravelLocations release];
    [_lblUserName release];
    [_lblTravelDate release];
    [_lblTravelPostTime release];
    [_mapImageView release];
    [super dealloc];
}
@end
