//
//  DropOffPointViewController.m
//  FriendShippr
//
//  Created by Zoondia on 24/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "DropOffPointViewController.h"

@interface DropOffPointViewController ()

@end

@implementation DropOffPointViewController
@synthesize dropOffMap,dropOffTable,txtPlaceSearch,dropOffArray,req,lblPickUpPlace,pickUpAnnotation,bttnLocArrow,currentLoc,currentPlace,placeActivityIndicator,locationManager,isfromShipReq;

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

-(void)searchForPlacesWithKeyword:(NSString*)searchKey{
    [self.placeActivityIndicator startAnimating];
    NSMutableString *trialUrlString=[[NSMutableString alloc] initWithString:Google_PlacesAPI_url];
    [trialUrlString appendFormat:@"address=%@",searchKey];
    [trialUrlString appendFormat:@"&sensor=true"];
    //[trialUrlString appendFormat:@"ll=%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    //[trialUrlString appendFormat:@"query=%@",searchKey];
    //[trialUrlString appendFormat:@"&key=%@",Google_PlacesAPI_Key];
    
    NSString *placesUrlString =[[NSString alloc] initWithString:trialUrlString];
    //NSLog(@"########venueUrlString=%@",placesUrlString);
    NSString *encodedPlacesUrlString=[placesUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [trialUrlString release];
    [placesUrlString release];
    
    [self.req cancel];
    NSURL *url = [[NSURL alloc] initWithString:encodedPlacesUrlString];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    self.req=request;
    [request setCompletionBlock:^{
        //[self.venueTable setHidden:NO];
        [self placesResponseRecievedWithString:[request responseString]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        //[self.loadingIndicator stopAnimating];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        //NSLog(@"response drop off point error=%@",[error localizedDescription]);
        if(![[error localizedDescription] isEqualToString:@"The request was cancelled"]){
            [Common showAlertwithTitle:@"Error Occured" alertString:[error localizedDescription] cancelbuttonName:@"OK"];
            //self.lblVenuesError.hidden=NO;
            //self.venueTable.hidden=YES;
            //self.lblVenuesError.text=@"Couldn't get Venues";
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        //[self.loadingIndicator stopAnimating];
    }];
    [request startAsynchronous];
    [url release];
}

-(void)placesResponseRecievedWithString:(NSString*)response{
    [self.placeActivityIndicator stopAnimating];
    //NSLog(@"response googleapi success=%@",response);
    NSDictionary *topDict=(NSDictionary*)[response JSONValue];
    NSArray *resultsArray=[topDict objectForKey:@"results"];
    if ([resultsArray count]>0) {
        [self.dropOffArray removeAllObjects];
        NSDictionary *productDict;
        NSString *address;
        NSString *lattitude;
        NSString *longitude;
        for (int i=0; i<[resultsArray count]; i++) {
            productDict=[resultsArray objectAtIndex:i];
            address=[productDict objectForKey:@"formatted_address"];
            lattitude=[[[productDict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
            longitude=[[[productDict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
            [self.dropOffArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:address,@"address",lattitude,@"lat",longitude,@"lng", nil]];
        }
        [self.dropOffTable reloadData];
    }
    else{
        NSLog(@"No places found");
        [self.dropOffArray addObject:@"No places found."];
    }
}

- (IBAction)bttnActionAutoLocation:(id)sender {
    if(([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)|| ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted)){
        [Common showAlertwithTitle:nil alertString:@"Enable Location Services" cancelbuttonName:@"OK"];
        return;
    }
    if(self.bttnLocArrow.selected==false){//Auto Location selected...
        [self.bttnLocArrow setSelected:true];
        CLLocation *currentLocObtained=[self.locationManager location];
        if(currentLocObtained!=nil){
            self.txtPlaceSearch.enabled=NO;
            self.navigationItem.leftBarButtonItem.enabled=NO;
            self.navigationItem.rightBarButtonItem.enabled=NO;
            //self.navigationItem.hidesBackButton = YES;
            progressHud = [[MBProgressHUD alloc] initWithView:self.view];
            progressHud.delegate = self;
            [self.view addSubview:progressHud];
            [progressHud show:YES];
            [self.dropOffArray removeAllObjects];
            [self.dropOffTable reloadData];
            CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
            [geoCoder reverseGeocodeLocation:currentLocObtained completionHandler:^(NSArray *placemarks, NSError *error) {
                if(error==nil){
                    NSMutableString *address=[[NSMutableString alloc] init];
                    for (CLPlacemark * placemark in placemarks)
                    {
                        if([placemark subThoroughfare]!=nil){
                            [address appendFormat:@"%@ ",[placemark subThoroughfare]];
                        }
                        if([placemark thoroughfare]!=nil){
                            [address appendFormat:@"%@ ",[placemark thoroughfare]];
                        }
                        if([placemark locality]!=nil){
                            [address appendFormat:@"%@, ",[placemark locality]];
                        }
                        if([placemark administrativeArea]!=nil){
                            [address appendFormat:@"%@, ",[placemark administrativeArea]];
                        }
                        if([placemark country]!=nil){
                            [address appendString:[placemark country]];
                        }
                        break;
                    }
                    [progressHud hide:YES];
                    if (address.length>0) {
                        self.currentLoc=currentLocObtained;
                        self.currentPlace=address;
                        NSLog(@"%@",address);
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Result" message:[NSString stringWithFormat:@"Your location is identified as \"%@\".\nDo you want to continue?",address] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                        alert.tag=5;
                        [alert show];
                        [alert release];
                    }
                    else{
                        [Common showAlertwithTitle:nil alertString:@"Cannot identify your location. Please try searching manually" cancelbuttonName:@"OK"];
                    }
                    [address release];
                    self.txtPlaceSearch.enabled=YES;
                    self.navigationItem.leftBarButtonItem.enabled=YES;
                    self.navigationItem.rightBarButtonItem.enabled=YES;
                    //self.navigationItem.hidesBackButton = NO;
                }
                else{
                    [Common showAlertwithTitle:@"Error Occurred" alertString:error.localizedDescription cancelbuttonName:@"OK"];
                }
            }];
        }
    }
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(self.isfromShipReq){
        self.navigationItem.title=@"Shipping Request";
        self.txtPlaceSearch.placeholder=@"What's your drop off point?";
    }
    else{
        self.navigationItem.title=@"Travel Route";
        self.txtPlaceSearch.placeholder=@"Where is your arrival point?";
    }
    
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
    
    //NSLog(@"lat=%f\n long=%f",[[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"lat"] floatValue],[[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"lng"] floatValue]);
    CLLocation *annotationLocation = [[CLLocation alloc]initWithLatitude:[[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"lat"] floatValue] longitude:[[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"lng"] floatValue]];
    if(self.isfromShipReq){
        pickUpAnnotation = [[MapViewAnnotation alloc] initWithTitle:@"Pickup Place" andCoordinate:annotationLocation.coordinate subtitle:nil];
    }
    else{
        pickUpAnnotation = [[MapViewAnnotation alloc] initWithTitle:@"Departure" andCoordinate:annotationLocation.coordinate subtitle:nil];
    }
	[self.dropOffMap addAnnotation:self.pickUpAnnotation];
    
    MKCoordinateRegion region;
    region.center = annotationLocation.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.07; // Change these values to change the zoom
    span.longitudeDelta = 0.07;
    region.span = span;
    [self.dropOffMap setRegion:region animated:YES];
    [annotationLocation release];
    
    dropOffArray=[[NSMutableArray alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 10 m
}

-(void)viewWillAppear:(BOOL)animated{
    if(self.isfromShipReq){
        self.lblPickUpPlace.text=[NSString stringWithFormat:@"PICK UP: %@",[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"address"]];
    }
    else{
        self.lblPickUpPlace.text=[NSString stringWithFormat:@"Departure: %@",[[ShippingRequestObject sharedInstance].pickUpPlace objectForKey:@"address"]];
    }
    
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    [self.req cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [locationManager release];locationManager=nil;
    [self.dropOffMap removeAnnotation:self.pickUpAnnotation];
    [pickUpAnnotation release];pickUpAnnotation=nil;
    self.dropOffMap.delegate=nil;
    [dropOffMap release];
    [req release];req=nil;
    [dropOffArray release];
    [txtPlaceSearch release];
    [dropOffTable release];
    [lblPickUpPlace release];
    [bttnLocArrow release];
    [placeActivityIndicator release];
    [currentPlace release];
    [currentLoc release];
    [super dealloc];
}



#pragma CLLocation delegates

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if(newLocation.coordinate.latitude!=0 && newLocation.coordinate.longitude!=0){
        
    }
}

#pragma mark MapView Delegates

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
     static NSString *pickUpAnnotationIdentifier=@"annotationIdentifier";
    
    if([annotation isKindOfClass:[MapViewAnnotation class]]){
        //Try to get an unused annotation, similar to uitableviewcells
         MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:pickUpAnnotationIdentifier];
        //If one isn't available, create a new one
        if(!annotationView){
            annotationView=[[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pickUpAnnotationIdentifier] autorelease];
            annotationView.canShowCallout=YES;
            if(self.isfromShipReq){
                annotationView.image=[UIImage imageNamed:@"location_P_orange.png"];
            }
            else{
                annotationView.image=[UIImage imageNamed:@"location_P_orange.png"];
            }
            annotationView.centerOffset=CGPointMake(0,-25);
        }
        return annotationView;
    }
    return nil;
}

#pragma mark TextField Delegates

- (IBAction)textFieldDidChangeText:(UITextField *)sender{
    [self searchForPlacesWithKeyword:sender.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dropOffArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"dropOffPlacesListCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines=0;
        cell.textLabel.lineBreakMode=UILineBreakModeWordWrap;
    }
    if([[self.dropOffArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]){
        cell.textLabel.text=[[self.dropOffArray objectAtIndex:indexPath.row] objectForKey:@"address"];
    }
    else{
        cell.textLabel.text=[self.dropOffArray objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row%2==0){
        cell.backgroundColor=[UIColor colorWithRed:0.94509 green:0.956862 blue:0.984313 alpha:1];
    }
    else{
        cell.backgroundColor=[UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str=nil;
    if([[self.dropOffArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]){
        str=[[self.dropOffArray objectAtIndex:indexPath.row] objectForKey:@"address"];
    }
    else{
        str=[self.dropOffArray objectAtIndex:indexPath.row];
    }
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 999) lineBreakMode:UILineBreakModeWordWrap];
    if((size.height+10)>44){
        return size.height+10;
    }
    else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isfromShipReq){
        if(indexPath.row==0){
            if([[self.dropOffArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]){
                self.txtPlaceSearch.text=@"";
                [self.txtPlaceSearch resignFirstResponder];
                
                PlaceConfirmViewController *placeConfirmView=[[PlaceConfirmViewController alloc] initWithNibName:@"PlaceConfirmViewController" bundle:[NSBundle mainBundle]];
                [ShippingRequestObject sharedInstance].dropOffPlace=[self.dropOffArray objectAtIndex:indexPath.row];
                placeConfirmView.isFromShippingRequest=self.isfromShipReq;
                [self.navigationController pushViewController:placeConfirmView animated:YES];
                [placeConfirmView release];
            }
        }
        else{
            self.txtPlaceSearch.text=@"";
            [self.txtPlaceSearch resignFirstResponder];
            
            PlaceConfirmViewController *placeConfirmView=[[PlaceConfirmViewController alloc] initWithNibName:@"PlaceConfirmViewController" bundle:[NSBundle mainBundle]];
            [ShippingRequestObject sharedInstance].dropOffPlace=[self.dropOffArray objectAtIndex:indexPath.row];
            placeConfirmView.isFromShippingRequest=self.isfromShipReq;
            [self.navigationController pushViewController:placeConfirmView animated:YES];
            [placeConfirmView release];
        }
    }
    else{
        if(indexPath.row==0){
            if([[self.dropOffArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]){
                self.txtPlaceSearch.text=@"";
                [self.txtPlaceSearch resignFirstResponder];
                
                DateEntryViewController *dateEntryView=[[DateEntryViewController alloc] initWithNibName:@"DateEntryViewController" bundle:[NSBundle mainBundle]];
                [ShippingRequestObject sharedInstance].dropOffPlace=[self.dropOffArray objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:dateEntryView animated:YES];
                [dateEntryView release];
            }
        }
        else{
            self.txtPlaceSearch.text=@"";
            [self.txtPlaceSearch resignFirstResponder];
            
            DateEntryViewController *dateEntryView=[[DateEntryViewController alloc] initWithNibName:@"DateEntryViewController" bundle:[NSBundle mainBundle]];
            [ShippingRequestObject sharedInstance].dropOffPlace=[self.dropOffArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:dateEntryView animated:YES];
            [dateEntryView release];
        }
    }
}

#pragma mark UIAlertview Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==5){
        if(buttonIndex==0){
            //cancel button clicked..
            [self.bttnLocArrow setSelected:false];
            self.currentPlace=nil;
            self.currentLoc=nil;
        }
        else{
            [self.bttnLocArrow setSelected:false];
            self.txtPlaceSearch.text=@"";
            [self.txtPlaceSearch resignFirstResponder];
            
            if(self.isfromShipReq){
                PlaceConfirmViewController *placeConfirmView=[[PlaceConfirmViewController alloc] initWithNibName:@"PlaceConfirmViewController" bundle:[NSBundle mainBundle]];
                [ShippingRequestObject sharedInstance].dropOffPlace=[NSDictionary dictionaryWithObjectsAndKeys:self.currentPlace,@"address",[NSString stringWithFormat:@"%f",self.currentLoc.coordinate.latitude],@"lat",[NSString stringWithFormat:@"%f",self.currentLoc.coordinate.longitude],@"lng", nil];
                placeConfirmView.isFromShippingRequest=self.isfromShipReq;
                [self.navigationController pushViewController:placeConfirmView animated:YES];
                [placeConfirmView release];
            }
            else{
                DateEntryViewController *dateEntryView=[[DateEntryViewController alloc] initWithNibName:@"DateEntryViewController" bundle:[NSBundle mainBundle]];
                [ShippingRequestObject sharedInstance].dropOffPlace=[NSDictionary dictionaryWithObjectsAndKeys:self.currentPlace,@"address",[NSString stringWithFormat:@"%f",self.currentLoc.coordinate.latitude],@"lat",[NSString stringWithFormat:@"%f",self.currentLoc.coordinate.longitude],@"lng", nil];
                [self.navigationController pushViewController:dateEntryView animated:YES];
                [dateEntryView release];
            }
            
            self.currentPlace=nil;
            self.currentLoc=nil;
        }
    }
}


@end
