//
//  RouteConfirmViewController.h
//  FriendShippr
//
//  Created by Zoondia on 06/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewAnnotation.h"
#import "ShippingRequestObject.h"
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "Common.h"

@interface RouteConfirmViewController : UIViewController<MKMapViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *progressHud;
}

@property(nonatomic,retain) MapViewAnnotation *departureAnnotation;
@property(nonatomic,retain) MapViewAnnotation *arrivalAnnotation;
@property (retain, nonatomic) IBOutlet MKMapView *routeConfirmMap;
@property (retain, nonatomic) IBOutlet UITextView *lbldepartureAddress;
@property (retain, nonatomic) IBOutlet UITextView *lblarrivalAddress;
@property (retain, nonatomic) IBOutlet UILabel *lblTravelDate;
- (IBAction)bttnActionPost:(id)sender;

@end
