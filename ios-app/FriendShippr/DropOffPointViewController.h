//
//  DropOffPointViewController.h
//  FriendShippr
//
//  Created by Zoondia on 24/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "Common.h"
#import "SBJson.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ShippingRequestObject.h"
#import "MapViewAnnotation.h"
#import "MBProgressHUD.h"
#import "PlaceConfirmViewController.h"
#import "DateEntryViewController.h"

@interface DropOffPointViewController : UIViewController<CLLocationManagerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>{
    MBProgressHUD *progressHud;
}

@property (assign, nonatomic) BOOL isfromShipReq;
@property (retain, nonatomic) IBOutlet MKMapView *dropOffMap;
@property (retain, nonatomic) IBOutlet UITextField *txtPlaceSearch;
@property (retain, nonatomic) IBOutlet UITableView *dropOffTable;
@property (retain, nonatomic) NSMutableArray *dropOffArray;
@property(nonatomic,retain)ASIHTTPRequest *req;
@property (retain, nonatomic) IBOutlet UILabel *lblPickUpPlace;
@property(nonatomic,retain) MapViewAnnotation *pickUpAnnotation;
@property (retain, nonatomic) IBOutlet UIButton *bttnLocArrow;
@property (retain, nonatomic) CLLocation *currentLoc;
@property (retain, nonatomic) NSString *currentPlace;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *placeActivityIndicator;
@property(nonatomic,retain) CLLocationManager *locationManager;

- (IBAction)bttnActionAutoLocation:(id)sender;
- (IBAction)textFieldDidChangeText:(UITextField *)sender;

@end
