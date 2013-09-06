//
//  RequestConfirmViewController.h
//  FriendShippr
//
//  Created by Zoondia on 29/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippingRequestObject.h"
#import "ShipRequestConfirmOrdinaryCell.h"
#import "ShipRequestConfirmProdCell.h"
#import "Common.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "ProductEntryViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "IntroDataSource.h"
#import "ProductConfirmSlide.h"

@interface RequestConfirmViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIScrollViewDelegate>{
    MBProgressHUD *progressHud;
}

@property (retain, nonatomic) IBOutlet UITableView *reqConfirmTable;
@property (retain, nonatomic) IBOutlet UILabel *lblUserName;
@property (retain, nonatomic) IBOutlet PFImageView *profileImgHolder;
@property (retain, nonatomic) IBOutlet UIScrollView *productImageHolder;
@property (retain, nonatomic) IBOutlet UIView *tblHeaderView;
@property (retain, nonatomic) ProductConfirmSlide *currentPage;
@property (retain, nonatomic) ProductConfirmSlide *nextPage;

@property(nonatomic,retain)NSMutableArray *selectedProductsArray;//array->dictionary(name,quantity)
@property(nonatomic,retain)NSDictionary *pickPlace;//dictionary(address,lat,lng)
@property(nonatomic,retain)NSDictionary *dropPlace;//dictionary(address,lat,lng)
@property(nonatomic,retain)NSString *dateOfDelivery;//either rush,week or anytime
@property(nonatomic,retain)NSString *termsOFPay;//either skrill,noPay or cod
@property(nonatomic,retain)NSString *karmaPts;
- (IBAction)btttnActionPostRequest:(id)sender;
@end
