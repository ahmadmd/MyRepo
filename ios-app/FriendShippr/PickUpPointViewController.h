//
//  PickUpPointViewController.h
//  FriendShippr
//
//  Created by Zoondia on 23/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "Common.h"
#import "SBJson.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ShippingRequestObject.h"
#import "DropOffPointViewController.h"
#import "MBProgressHUD.h"

@interface PickUpPointViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *progressHud;
}
@property (assign, nonatomic) BOOL isFromShippingReq;
@property (retain, nonatomic) IBOutlet UITextField *txtPlaceEntry;
@property (retain, nonatomic) IBOutlet UITableView *pickUpPlaceTable;
@property (retain, nonatomic) NSMutableArray *pickUpPlacesArray;
- (IBAction)textFieldDidChangeText:(UITextField *)sender;
@property(nonatomic,retain)ASIHTTPRequest *req;
@property (retain, nonatomic) IBOutlet MKMapView *pickUpPlaceMap;
@property (retain, nonatomic) IBOutlet UIButton *bttnLocArrow;
@property (retain, nonatomic) MKUserLocation *currentLoc;
@property (retain, nonatomic) NSString *currentPlace;
- (IBAction)bttnActionAutoLocation:(id)sender;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *placeActivityIndicator;

@end
