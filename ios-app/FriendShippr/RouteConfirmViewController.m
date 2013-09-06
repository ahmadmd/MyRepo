//
//  RouteConfirmViewController.m
//  FriendShippr
//
//  Created by Zoondia on 06/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "RouteConfirmViewController.h"

@interface RouteConfirmViewController ()

@end

@implementation RouteConfirmViewController
@synthesize departureAnnotation,arrivalAnnotation,lblarrivalAddress,lbldepartureAddress,routeConfirmMap,lblTravelDate;

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

- (IBAction)bttnActionPost:(id)sender{
    progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    progressHud.delegate = self;
    [self.view addSubview:progressHud];
    [progressHud show:YES];
    
    NSDictionary *pickUpDict=[NSDictionary dictionaryWithObjectsAndKeys:[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"lat"],@"latt",[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"lng"],@"long", nil];
    NSDictionary *dropOffDict=[NSDictionary dictionaryWithObjectsAndKeys:[[ShippingRequestObject sharedInstance].dropOffPlace objectForKey:@"lat"],@"latt",[[ShippingRequestObject sharedInstance].dropOffPlace objectForKey:@"lng"],@"long", nil];
    
    PFObject *routeObj = [PFObject objectWithClassName:kFSRouteClassKey];
    [routeObj setObject:[PFUser currentUser] forKey:kFSRouteFromUserKey];
    [routeObj setObject:[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"address"] forKey:kFSRouteFromStreetKey];
    [routeObj setObject:pickUpDict forKey:kFSRouteFromCoordinateKey];
    [routeObj setObject:[[ShippingRequestObject sharedInstance].dropOffPlace objectForKey:@"address"] forKey:kFSRouteToStreetKey];
    [routeObj setObject:dropOffDict forKey:kFSRouteToCoordinateKey];
    [routeObj setObject:[ShippingRequestObject sharedInstance].travelDate forKey:kFSRouteDepartureDateKey];
    [routeObj saveInBackgroundWithBlock:^(BOOL succeed,NSError *error){
        [progressHud hide:YES];
        if(succeed){
            
            [ShippingRequestObject sharedInstance].pickUpPlace=nil;
            [ShippingRequestObject sharedInstance].dropOffPlace=nil;
            [ShippingRequestObject sharedInstance].travelDate=nil;
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^(){
                [Common showAlertwithTitle:nil alertString:@"Travel Route successfully posted" cancelbuttonName:@"OK"];
            }];
        }
        else{
            [Common showAlertwithTitle:@"Error Occured" alertString:error.localizedDescription cancelbuttonName:@"OK"];
        }
    }];
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"Travel Route";
    
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
    departureAnnotation = [[MapViewAnnotation alloc] initWithTitle:@"Departure" andCoordinate:pickupLocation.coordinate subtitle:nil];
	[self.routeConfirmMap addAnnotation:self.departureAnnotation];
    
    
    CLLocation *dropoffLocation = [[CLLocation alloc]initWithLatitude:[[[ShippingRequestObject sharedInstance].dropOffPlace objectForKey:@"lat"] floatValue] longitude:[[[ShippingRequestObject sharedInstance].dropOffPlace objectForKey:@"lng"] doubleValue]];
    arrivalAnnotation = [[MapViewAnnotation alloc] initWithTitle:@"Arrival" andCoordinate:dropoffLocation.coordinate subtitle:nil];
    [self.routeConfirmMap addAnnotation:self.arrivalAnnotation];
    
    CLLocationCoordinate2D coordinateArray[2];
    coordinateArray[0] = pickupLocation.coordinate;
    coordinateArray[1] = dropoffLocation.coordinate;
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
    [self.routeConfirmMap addOverlay:polyLine];
    
    
    [pickupLocation release];
    [dropoffLocation release];
}

-(void)viewWillAppear:(BOOL)animated{
    self.lbldepartureAddress.text=[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"address"];
    self.lblarrivalAddress.text=[[ShippingRequestObject sharedInstance].dropOffPlace objectForKey:@"address"];
    
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd,yyyy"];
    NSString *selectedDate=[dateFormatter stringFromDate:[ShippingRequestObject sharedInstance].travelDate];
    [dateFormatter release];
    self.lblTravelDate.text=[NSString stringWithFormat:@"%@   ",selectedDate];
    
    [self zoomToFitMapAnnotations:self.routeConfirmMap];
}

- (void)dealloc {
    [self.routeConfirmMap removeAnnotation:self.departureAnnotation];
    [self.routeConfirmMap removeAnnotation:self.arrivalAnnotation];
    [departureAnnotation release];departureAnnotation=nil;
    [arrivalAnnotation release];arrivalAnnotation=nil;
    self.routeConfirmMap.delegate=nil;
    [routeConfirmMap release];
    [lblarrivalAddress release];
    [lbldepartureAddress release];
    [lblTravelDate release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
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
        if(annotation==self.departureAnnotation){
            MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:pickupAnnotationIdentifier];
            //If one isn't available, create a new one
            if(!annotationView){
                annotationView=[[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pickupAnnotationIdentifier] autorelease];
                annotationView.canShowCallout=YES;
                annotationView.image=[UIImage imageNamed:@"location_D_green.png"];
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
                annotationView.image=[UIImage imageNamed:@"location_A_red.png"];
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

#pragma mark MBProgressHUD Delegates

- (void)hudWasHidden:(MBProgressHUD *)hud {// Remove HUD from screen when the HUD was hidded
	[progressHud removeFromSuperview];
	[progressHud release];
	progressHud = nil;
}

@end
