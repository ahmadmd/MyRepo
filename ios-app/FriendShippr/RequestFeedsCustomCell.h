//
//  RequestFeedsCustomCell.h
//  FriendShippr
//
//  Created by Zoondia on 03/09/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProductScrollCustomCell.h"
#import "UIImage+ResizeAdditions.h"

@interface RequestFeedsCustomCell : PFTableViewCell<UITableViewDelegate,UITableViewDataSource>

+ (NSString *)reuseIdentifierFeed;
+ (NSString *)reuseIdentifierHub;

@property (retain, nonatomic) NSArray *imageUrls;
@property (retain, nonatomic) IBOutlet UILabel *lblProductShippingName;
@property (retain, nonatomic) IBOutlet UILabel *lblShippingLocation;
@property (retain, nonatomic) IBOutlet UILabel *lblKarmaPoints;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrentUser;
@property (retain, nonatomic) IBOutlet UIView *repostViewHolder;
@property (retain, nonatomic) IBOutlet UILabel *lblTimeDisplay;
@property (retain, nonatomic) IBOutlet UITableView *tableImageHolder;
//@property (assign, nonatomic) int selectedRow;

- (IBAction)bttnActionRepost:(id)sender;
-(void)reloadTableData;

@end
