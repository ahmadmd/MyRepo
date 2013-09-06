//
//  PickUpPointViewController.m
//  FriendShippr
//
//  Created by Zoondia on 23/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "PickUpPointViewController.h"

@interface PickUpPointViewController ()

@end

@implementation PickUpPointViewController
@synthesize txtPlaceEntry,pickUpPlacesArray,pickUpPlaceTable,req,pickUpPlaceMap,bttnLocArrow,placeActivityIndicator,currentLoc,currentPlace,isFromShippingReq;

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
        // NSLog(@"response pick up point error=%@",[error localizedDescription]);
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
    // NSLog(@"response googleapi success=%@",response);
    [self.placeActivityIndicator stopAnimating];
    NSDictionary *topDict=(NSDictionary*)[response JSONValue];
    NSArray *resultsArray=[topDict objectForKey:@"results"];
    if ([resultsArray count]>0) {
        [self.pickUpPlacesArray removeAllObjects];
        NSDictionary *productDict;
        NSString *address;
        NSString *lattitude;
        NSString *longitude;
        for (int i=0; i<[resultsArray count]; i++) {
            productDict=[resultsArray objectAtIndex:i];
            address=[productDict objectForKey:@"formatted_address"];
            lattitude=[[[productDict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
            longitude=[[[productDict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
            [self.pickUpPlacesArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:address,@"address",lattitude,@"lat",longitude,@"lng", nil]];
        }
        [self.pickUpPlaceTable reloadData];
    }
    else{
        NSLog(@"No places found");
        [self.pickUpPlacesArray addObject:@"No places found."];
    }
}

- (IBAction)bttnActionAutoLocation:(id)sender {
    if(([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)|| ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted)){
        [Common showAlertwithTitle:nil alertString:@"Enable Location Services" cancelbuttonName:@"OK"];
        return;
    }
    if(self.bttnLocArrow.selected==false){//Auto Location selected...
        [self.bttnLocArrow setSelected:true];
        MKUserLocation *currentLocObtained=[self.pickUpPlaceMap userLocation];
        if(currentLocObtained!=nil){
            self.txtPlaceEntry.enabled=NO;
            self.navigationItem.leftBarButtonItem.enabled=NO;
            self.navigationItem.rightBarButtonItem.enabled=NO;
            // self.navigationItem.hidesBackButton = YES;
            progressHud = [[MBProgressHUD alloc] initWithView:self.view];
            progressHud.delegate = self;
            [self.view addSubview:progressHud];
            [progressHud show:YES];
            [self.pickUpPlacesArray removeAllObjects];
            [self.pickUpPlaceTable reloadData];
            CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
            [geoCoder reverseGeocodeLocation:currentLocObtained.location completionHandler:^(NSArray *placemarks, NSError *error) {
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
                    self.txtPlaceEntry.enabled=YES;
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
    pickUpPlacesArray=[[NSMutableArray alloc] init];
    
    if(self.isFromShippingReq){
        self.navigationItem.title=@"Shipping Request";
        self.txtPlaceEntry.placeholder=@"What's your pick up point?";
        
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
    }
    else{
        self.navigationItem.title=@"Travel Route";
        self.txtPlaceEntry.placeholder=@"Where is your departure point?";
    }
    
    
    
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
    
    //self.pickUpPlaceMap.frame=CGRectMake(self.pickUpPlaceMap.frame.origin.x, self.pickUpPlaceMap.frame.origin.y, self.pickUpPlaceMap.frame.size.width, [UIScreen mainScreen].bounds.size.height);
}

-(void)viewWillAppear:(BOOL)animated{
    [self.pickUpPlaceMap setShowsUserLocation:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.pickUpPlaceMap setShowsUserLocation:NO];
    [self.req cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    self.pickUpPlaceMap.delegate=nil;
    [pickUpPlaceMap release];
    [req release];req=nil;
    //[productsArray release];
    [currentPlace release];
    [currentLoc release];
    [pickUpPlacesArray release];
    [txtPlaceEntry release];
    [pickUpPlaceTable release];
    [bttnLocArrow release];
    [placeActivityIndicator release];
    [super dealloc];
}



#pragma mark TextField Delegates

- (IBAction)textFieldDidChangeText:(UITextField *)sender {
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
    return [self.pickUpPlacesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"pickupPlacesListCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines=0;
        cell.textLabel.lineBreakMode=UILineBreakModeWordWrap;
    }
    if([[self.pickUpPlacesArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]){
        cell.textLabel.text=[[self.pickUpPlacesArray objectAtIndex:indexPath.row] objectForKey:@"address"];
    }
    else{
        cell.textLabel.text=[self.pickUpPlacesArray objectAtIndex:indexPath.row];
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
    if([[self.pickUpPlacesArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]){
        str=[[self.pickUpPlacesArray objectAtIndex:indexPath.row] objectForKey:@"address"];
    }
    else{
        str=[self.pickUpPlacesArray objectAtIndex:indexPath.row];
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
    if(indexPath.row==0){
        if([[self.pickUpPlacesArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]){
            self.txtPlaceEntry.text=@"";
            [self.txtPlaceEntry resignFirstResponder];
            
            DropOffPointViewController *dropView=[[DropOffPointViewController alloc] initWithNibName:@"DropOffPointViewController" bundle:[NSBundle mainBundle]];
            [ShippingRequestObject sharedInstance].pickUpPlace=[self.pickUpPlacesArray objectAtIndex:indexPath.row];
            dropView.isfromShipReq=self.isFromShippingReq;
            [self.navigationController pushViewController:dropView animated:YES];
            [dropView release];
        }
    }
    else{
        self.txtPlaceEntry.text=@"";
        [self.txtPlaceEntry resignFirstResponder];
        
        DropOffPointViewController *dropView=[[DropOffPointViewController alloc] initWithNibName:@"DropOffPointViewController" bundle:[NSBundle mainBundle]];
        [ShippingRequestObject sharedInstance].pickUpPlace=[self.pickUpPlacesArray objectAtIndex:indexPath.row];
        dropView.isfromShipReq=self.isFromShippingReq;
        [self.navigationController pushViewController:dropView animated:YES];
        [dropView release];
    }
}

#pragma mark Mapview Delegates

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(userLocation.coordinate.latitude!=0 && userLocation.coordinate.longitude!=0){
        //self.currentLoc=userLocation;
        MKCoordinateRegion region;
        region.center = userLocation.coordinate;
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.7; // Change these values to change the zoom
        span.longitudeDelta = 0.7;
        region.span = span;
        [self.pickUpPlaceMap setRegion:region animated:YES];
    }
}

#pragma mark MBProgressHUD Delegates

- (void)hudWasHidden:(MBProgressHUD *)hud {// Remove HUD from screen when the HUD was hidded
	[progressHud removeFromSuperview];
	[progressHud release];
	progressHud = nil;
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
            self.txtPlaceEntry.text=@"";
            [self.txtPlaceEntry resignFirstResponder];
            
            DropOffPointViewController *dropView=[[DropOffPointViewController alloc] initWithNibName:@"DropOffPointViewController" bundle:[NSBundle mainBundle]];
            [ShippingRequestObject sharedInstance].pickUpPlace=[NSDictionary dictionaryWithObjectsAndKeys:self.currentPlace,@"address",[NSString stringWithFormat:@"%f",self.currentLoc.coordinate.latitude],@"lat",[NSString stringWithFormat:@"%f",self.currentLoc.coordinate.longitude],@"lng", nil];
            dropView.isfromShipReq=self.isFromShippingReq;
            [self.navigationController pushViewController:dropView animated:YES];
            [dropView release];
            
            self.currentPlace=nil;
            self.currentLoc=nil;
        }
    }
}


@end
