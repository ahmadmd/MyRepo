//
//  HubCustomCell.h
//  FriendShippr
//
//  Created by Zoondia on 16/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SlideViewController.h"

@class SlideViewController;

@interface HubCustomCell : PFTableViewCell
+ (NSString *)reuseIdentifier;

@property (retain, nonatomic) NSArray *imageUrls;
@property (retain, nonatomic)SlideViewController *currentPage;
@property (retain, nonatomic)SlideViewController *nextPage;


@property (retain, nonatomic) IBOutlet UILabel *lblProductShippingName;
@property (retain, nonatomic) IBOutlet UILabel *lblShippingLocation;
@property (retain, nonatomic) IBOutlet UILabel *lblKarmaPoints;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrentUser;
@property (retain, nonatomic) IBOutlet UIView *repostViewHolder;
@property (retain, nonatomic) IBOutlet UILabel *lblTimeDisplay;

- (NSInteger)numDataPages;
- (NSString *)dataForPage:(NSInteger)pageIndex;
- (IBAction)bttnActionRepost:(id)sender;
@end
