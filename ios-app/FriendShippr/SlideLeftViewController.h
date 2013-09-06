//
//  SlideLeftViewController.h
//  FriendShippr
//
//  Created by Zoondia on 16/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "IIViewDeckController.h"
#import "SlideCustomCell.h"
#import <Parse/Parse.h>

@interface SlideLeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *sideMenuTable;
@property (retain, nonatomic) NSMutableArray *menuListArray;
@property (retain, nonatomic) IBOutlet UIView *tblHeaderView;
@property (retain, nonatomic) IBOutlet UIView *tblFooterView;
@property (retain, nonatomic) IBOutlet PFImageView *profileImgHolder;
- (IBAction)bttnActionLogout:(id)sender;
@end
