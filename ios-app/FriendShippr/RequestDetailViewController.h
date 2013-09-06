//
//  RequestDetailViewController.h
//  FriendShippr
//
//  Created by Zoondia on 26/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "ProductConfirmSlide.h"
#import "ShipRequestConfirmProdCell.h"
#import "ShipRequestConfirmOrdinaryCell.h"
#import "Common.h"
#import "ForwardFriendSelectViewController.h"

@interface RequestDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIScrollViewDelegate>{
    MBProgressHUD *progressHud;
}

@property(nonatomic,retain)PFObject *shippingReqObj;
@property(nonatomic,retain)PFUser *userObj;

@property (retain, nonatomic) IBOutlet UITableView *tableReq;
@property (retain, nonatomic) IBOutlet UILabel *lblUserName;
@property (retain, nonatomic) IBOutlet PFImageView *profileImgHolder;
@property (retain, nonatomic) IBOutlet UIScrollView *productImageHolder;
@property (retain, nonatomic) IBOutlet UIView *tblHeaderView;
@property (retain, nonatomic) ProductConfirmSlide *currentPage;
@property (retain, nonatomic) ProductConfirmSlide *nextPage;

- (IBAction)bttnActionForward:(id)sender;
- (IBAction)bttnActionIDoIt:(id)sender;
@end
