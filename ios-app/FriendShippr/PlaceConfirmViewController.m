//
//  PlaceConfirmViewController.m
//  FriendShippr
//
//  Created by Zoondia on 24/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "PlaceConfirmViewController.h"

@interface PlaceConfirmViewController ()

@end

@implementation PlaceConfirmViewController
@synthesize placeConfirmMap,pickUpAnnotation,dropOffAnnotation,lblDropOffAddress,lblPickUpAddress,isFromShippingRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)bttnActionClose:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)bttnActionGoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bttnActionForward:(id)sender {
    DeliveryDateViewController *deliveryView=[[DeliveryDateViewController alloc] initWithNibName:@"DeliveryDateViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:deliveryView animated:YES];
    [deliveryView release];
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"Shipping Request";
    
    UIImage *leftimage = [UIImage imageNamed:navBarBackBttn];
    CGRect frameimg = CGRectMake(0, 0, leftimage.size.width, leftimage.size.height);
    UIButton *leftButton = [[UIButton alloc] initWithFrame:frameimg];
    [leftButton setBackgroundImage:leftimage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(bttnActionGoBack:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarbutton =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=leftBarbutton;
    [leftButton release];
    [leftBarbutton release];
    
    UIImage* rightImage = [UIImage imageNamed:navBarRightCloseBttn];
    CGRect rightImageframe = CGRectMake(0, 0, 16, 16);
    UIButton *rightButton = [[UIButton alloc] initWithFrame:rightImageframe];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(bttnActionClose:)
          forControlEvents:UIControlEventTouchUpInside];
    [rightButton setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *rightBarbutton =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightBarbutton;
    [rightButton release];
    [rightBarbutton release];
    
    CLLocation *pickupLocation = [[CLLocation alloc]initWithLatitude:[[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"lat"] floatValue] longitude:[[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"lng"] doubleValue]];
    pickUpAnnotation = [[MapViewAnnotation alloc] initWithTitle:@"Pickup Place" andCoordinate:pickupLocation.coordinate subtitle:nil];
	[self.placeConfirmMap addAnnotation:self.pickUpAnnotation];
    
    
    CLLocation *dropoffLocation = [[CLLocation alloc]initWithLatitude:[[[ShippingRequestObject sharedInstance].dropOffPlace objectForKey:@"lat"] floatValue] longitude:[[[ShippingRequestObject sharedInstance].dropOffPlace objectForKey:@"lng"] doubleValue]];
    dropOffAnnotation = [[MapViewAnnotation alloc] initWithTitle:@"Dropoff Place" andCoordinate:dropoffLocation.coordinate subtitle:nil];
    [self.placeConfirmMap addAnnotation:self.dropOffAnnotation];
    
    CLLocationCoordinate2D coordinateArray[2];
    coordinateArray[0] = pickupLocation.coordinate;
    coordinateArray[1] = dropoffLocation.coordinate;
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
    [self.placeConfirmMap addOverlay:polyLine];
   
    
    [pickupLocation release];
    [dropoffLocation release];
    
    //[self zoomToFitMapAnnotations:self.placeConfirmMap];
}

-(void)viewWillAppear:(BOOL)animated{
    self.lblPickUpAddress.text=[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"address"];
    self.lblDropOffAddress.text=[[ShippingRequestObject sharedInstance].dropOffPlace objectForKey:@"address"];
    
    [self zoomToFitMapAnnotations:self.placeConfirmMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [self.placeConfirmMap removeAnnotation:self.pickUpAnnotation];
    [self.placeConfirmMap removeAnnotation:self.dropOffAnnotation];
    [pickUpAnnotation release];pickUpAnnotation=nil;
    [dropOffAnnotation release];dropOffAnnotation=nil;
    //[self.placeConfirmMap removeOverlay:];
    self.placeConfirmMap.delegate=nil;
    [placeConfirmMap release];
    [lblPickUpAddress release];
    [lblDropOffAddress release];
    [super dealloc];
}

#pragma mark Mapview Delegates


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
    polylineView.strokeColor = [UIColor orangeColor];
    polylineView.lineWidth = 2.0;
    polylineView.lineDashPattern=[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3], nil];
    polylineView.lineCap=kCGLineCapRound;
    return polylineView;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *pickupAnnotationIdentifier=@"pickupAnnotationIdentifier";
    static NSString *dropoffAnnotationIdentifier=@"dropoffAnnotationIdentifier";
    
    if([annotation isKindOfClass:[MapViewAnnotation class]]){
        //Try to get an unused annotation, similar to uitableviewcells
        if(annotation==self.pickUpAnnotation){
            MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:pickupAnnotationIdentifier];
            //If one isn't available, create a new one
            if(!annotationView){
                annotationView=[[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pickupAnnotationIdentifier] autorelease];
                annotationView.canShowCallout=YES;
                annotationView.image=[UIImage imageNamed:@"location_P_orange.png"];
                annotationView.centerOffset=CGPointMake(0,-25);
            }
            return annotationView;
        }
        else{
            MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:dropoffAnnotationIdentifier];
            //If one isn't available, create a new one
            if(!annotationView){
                annotationView=[[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:dropoffAnnotationIdentifier] autorelease];
                annotationView.canShowCallout=YES;
                annotationView.image=[UIImage imageNamed:@"location_D_yellow.png"];
                annotationView.centerOffset=CGPointMake(0,-25);
            }
            return annotationView;
        }
    }
    return nil;
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView1 {
    if ([mapView1.annotations count] == 0) return;
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -120;
    topLeftCoord.longitude = 200;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 120;
    bottomRightCoord.longitude = -200;
    
    for(MapViewAnnotation *annotation1 in mapView1.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation1.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation1.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation1.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation1.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    // Add a little extra space on the sides
    region = [mapView1 regionThatFits:region];
    [mapView1 setRegion:region animated:YES];
}



@end
