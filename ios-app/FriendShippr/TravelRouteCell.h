//
//  TravelRouteCell.h
//  FriendShippr
//
//  Created by Zoondia on 27/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelRouteCell : UITableViewCell

+ (NSString *)reuseIdentifier;
@property (retain, nonatomic) IBOutlet UILabel *lblTravelLocations;
@property (retain, nonatomic) IBOutlet UILabel *lblUserName;
@property (retain, nonatomic) IBOutlet UILabel *lblTravelDate;
@property (retain, nonatomic) IBOutlet UILabel *lblTravelPostTime;
@property (retain, nonatomic) IBOutlet UIImageView *mapImageView;
@end
