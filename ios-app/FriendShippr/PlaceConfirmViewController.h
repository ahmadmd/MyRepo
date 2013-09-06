//
//  PlaceConfirmViewController.h
//  FriendShippr
//
//  Created by Zoondia on 24/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewAnnotation.h"
#import "ShippingRequestObject.h"
#import <MapKit/MapKit.h>
#import "DeliveryDateViewController.h"

@interface PlaceConfirmViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic,assign) BOOL isFromShippingRequest;
@property(nonatomic,retain) MapViewAnnotation *pickUpAnnotation;
@property(nonatomic,retain) MapViewAnnotation *dropOffAnnotation;
@property (retain, nonatomic) IBOutlet MKMapView *placeConfirmMap;
@property (retain, nonatomic) IBOutlet UITextView *lblPickUpAddress;
@property (retain, nonatomic) IBOutlet UITextView *lblDropOffAddress;
- (IBAction)bttnActionForward:(id)sender;

@end
