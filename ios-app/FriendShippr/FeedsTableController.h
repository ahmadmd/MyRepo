//
//  FeedsTableController.h
//  FriendShippr
//
//  Created by Zoondia on 23/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TTTTimeIntervalFormatter.h"
#import "UserJoinedCell.h"
#import "Common.h"
#import "RequestDetailViewController.h"
#import "TravelRouteCell.h"
#import "RequestFeedsCustomCell.h"

@interface FeedsTableController : PFQueryTableViewController

@property(nonatomic,retain)NSArray *friendsArray;

@end
