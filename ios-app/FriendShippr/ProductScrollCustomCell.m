//
//  ProductScrollCustomCell.m
//  FriendShippr
//
//  Created by Zoondia on 03/09/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "ProductScrollCustomCell.h"

@implementation ProductScrollCustomCell

+ (NSString *)reuseIdentifier{
    return @"productScrollCustomCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [_productImageHolder release];
    [super dealloc];
}

@end
