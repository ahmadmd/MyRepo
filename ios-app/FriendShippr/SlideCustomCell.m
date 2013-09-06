//
//  SlideCustomCell.m
//  FriendShippr
//
//  Created by Zoondia on 05/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "SlideCustomCell.h"

@implementation SlideCustomCell

+ (NSString *)reuseIdentifier{
    return @"slideCustomIdentifier";
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
    [_bgView release];
    [_imageHolder release];
    [_name release];
    [super dealloc];
}
@end
