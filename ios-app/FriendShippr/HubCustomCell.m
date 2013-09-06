//
//  HubCustomCell.m
//  FriendShippr
//
//  Created by Zoondia on 16/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "HubCustomCell.h"

@implementation HubCustomCell
@synthesize imageUrls,currentPage,nextPage;

+ (NSString *)reuseIdentifier{
    return @"hubCellIdentifier";
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

- (NSInteger)numDataPages
{
	return [self.imageUrls count];
}

- (NSString *)dataForPage:(NSInteger)pageIndex
{
	return [self.imageUrls objectAtIndex:pageIndex];
}

- (IBAction)bttnActionRepost:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:FSShippingRequestRepostCellNotification object:self];
}

- (void)dealloc {
    [_lblProductShippingName release];
    [_lblShippingLocation release];
    [_lblKarmaPoints release];
    [imageUrls release];
    [currentPage release];
    [nextPage release];
    [_lblCurrentUser release];
    [_repostViewHolder release];
    [_lblTimeDisplay release];
    [super dealloc];
}
@end
