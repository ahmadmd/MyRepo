//
//  RequestConfirmViewController.m
//  FriendShippr
//
//  Created by Zoondia on 29/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "RequestConfirmViewController.h"

@interface RequestConfirmViewController ()

@end

@implementation RequestConfirmViewController
@synthesize selectedProductsArray,pickPlace,dropPlace,dateOfDelivery,termsOFPay,karmaPts,reqConfirmTable,lblUserName,productImageHolder,profileImgHolder,tblHeaderView,currentPage,nextPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)applyNewIndex:(NSInteger)newIndex pageController:(ProductConfirmSlide *)pageController
{
	NSInteger pageCount = [[IntroDataSource sharedDataSource] numDataPages:NO];
	BOOL outOfBounds = newIndex >= pageCount || newIndex < 0;
    
	if (!outOfBounds)
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = 0;
		pageFrame.origin.x = self.productImageHolder.frame.size.width * newIndex;
		pageController.view.frame = pageFrame;
	}
	else
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = self.productImageHolder.frame.size.height;
		pageController.view.frame = pageFrame;
	}
    
	pageController.pageIndex = newIndex;
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    //self.productImageHolder.delegate=self;
    
    
    /* productImageHolder = [[PFImageView alloc] initWithFrame:CGRectMake( 0.0f, 32.0f, 320.0f, 135.0f)];
     self.productImageHolder.image=[UIImage imageNamed:@"NoProduct.gif"];
     [self.tblHeaderView addSubview:self.productImageHolder];*/
    
    
    profileImgHolder = [[PFImageView alloc] initWithFrame:CGRectMake( 4.0f, 5.0f, 44.0f, 44.0f)];
    [self.profileImgHolder setContentMode:UIViewContentModeScaleAspectFill];
    self.profileImgHolder.alpha=0.0f;
    [self.tblHeaderView addSubview:self.profileImgHolder];
    
    self.reqConfirmTable.tableHeaderView=self.tblHeaderView;
}

-(void)viewWillAppear:(BOOL)animated{
    self.lblUserName.text=[[PFUser currentUser] objectForKey:kFSUserDisplayNameKey];
    
    PFFile *imageFile = [[PFUser currentUser] objectForKey:kFSUserProfilePicSmallKey];
    if (imageFile) {
        [self.profileImgHolder setFile:imageFile];
        [self.profileImgHolder loadInBackground:^(UIImage *image, NSError *error) {
            if (!error) {
                [UIView animateWithDuration:0.200f animations:^{
                    self.profileImgHolder.alpha = 1.0f;
                }];
            }
        }];
    }
    
    
    NSArray *products=[ShippingRequestObject sharedInstance].productsArray;
    NSMutableArray *prodImgUrls=[[NSMutableArray alloc] init];
    NSDictionary *prodDict;
    for(int i=0;i<[products count];i++){
        prodDict=[products objectAtIndex:i];
        [prodImgUrls addObject:[prodDict objectForKey:@"imageUrl"]];
    }
    [IntroDataSource sharedDataSource].imageUrls=prodImgUrls;
    [prodImgUrls release];
    
    
    currentPage = [[ProductConfirmSlide alloc] initWithNibName:@"ProductConfirmSlide" bundle:nil];
	nextPage = [[ProductConfirmSlide alloc] initWithNibName:@"ProductConfirmSlide" bundle:nil];
	[self.productImageHolder addSubview:currentPage.view];
	[self.productImageHolder addSubview:nextPage.view];
    
	NSInteger widthCount = [[IntroDataSource sharedDataSource] numDataPages:NO];
	if (widthCount == 0)
	{
		widthCount = 1;
	}
	
    self.productImageHolder.contentSize =
    CGSizeMake(
               self.productImageHolder.frame.size.width * widthCount,
               self.productImageHolder.frame.size.height);
	self.productImageHolder.contentOffset = CGPointMake(0, 0);
	
	[self applyNewIndex:0 pageController:currentPage];
	[self applyNewIndex:1 pageController:nextPage];
    
    
    self.selectedProductsArray=[ShippingRequestObject sharedInstance].productsArray;
    self.pickPlace=[ShippingRequestObject sharedInstance].pickUpPlace;
    self.dropPlace=[ShippingRequestObject sharedInstance].dropOffPlace;
    self.dateOfDelivery=[ShippingRequestObject sharedInstance].deliveryDate;
    self.termsOFPay=[ShippingRequestObject sharedInstance].paymentTerms;
    self.karmaPts=[ShippingRequestObject sharedInstance].karmaPoints;
    [self.reqConfirmTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [reqConfirmTable release];
    [lblUserName release];
    [profileImgHolder release];
    [productImageHolder release];
    [tblHeaderView release];
    [currentPage release];
    [nextPage release];
    [super dealloc];
}

#pragma mark UIScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if(sender.tag==5){
        CGFloat pageWidth = self.productImageHolder.frame.size.width;
        float fractionalPage = self.productImageHolder.contentOffset.x / pageWidth;
        
        NSInteger lowerNumber = floor(fractionalPage);
        NSInteger upperNumber = lowerNumber + 1;
        
        if (lowerNumber == currentPage.pageIndex)
        {
            if (upperNumber != nextPage.pageIndex)
            {
                [self applyNewIndex:upperNumber pageController:nextPage];
            }
        }
        else if (upperNumber == currentPage.pageIndex)
        {
            if (lowerNumber != nextPage.pageIndex)
            {
                [self applyNewIndex:lowerNumber pageController:nextPage];
            }
        }
        else
        {
            if (lowerNumber == nextPage.pageIndex)
            {
                [self applyNewIndex:upperNumber pageController:currentPage];
            }
            else if (upperNumber == nextPage.pageIndex)
            {
                [self applyNewIndex:lowerNumber pageController:currentPage];
            }
            else
            {
                [self applyNewIndex:lowerNumber pageController:currentPage];
                [self applyNewIndex:upperNumber pageController:nextPage];
            }
        }
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView
{
    if(newScrollView.tag==5){
        CGFloat pageWidth = self.productImageHolder.frame.size.width;
        float fractionalPage = self.productImageHolder.contentOffset.x / pageWidth;
        NSInteger nearestNumber = lround(fractionalPage);
        
        if (currentPage.pageIndex != nearestNumber)
        {
            ProductConfirmSlide *swapController = currentPage;
            currentPage = nextPage;
            nextPage = swapController;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
    if(newScrollView.tag==5){
        [self scrollViewDidEndScrollingAnimation:newScrollView];
        //self.pageNumberControl.currentPage = currentPage.pageIndex;
    }
}

#pragma mark TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.selectedProductsArray count]+4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row<[self.selectedProductsArray count]){
        ShipRequestConfirmProdCell *cell =nil;
        //ShipRequestConfirmProductCell *cell=(ShipRequestConfirmProductCell *) [tableView dequeueReusableCellWithIdentifier:[ShipRequestConfirmProductCell reuseIdentifier]];
        
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShipRequestConfirmProdCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (ShipRequestConfirmProdCell *)currentObject;
                    break;
                }
            }
        }
        
        if(indexPath.row%2==0){
            cell.contentView.backgroundColor=[UIColor colorWithRed:0.94509 green:0.956862 blue:0.984313 alpha:1];
        }
        else{
            cell.contentView.backgroundColor=[UIColor whiteColor];
        }
        NSDictionary *productDetails=(NSDictionary*)[self.selectedProductsArray objectAtIndex:indexPath.row];
        cell.lblProductNumber.text=[NSString stringWithFormat:@"%d",[[productDetails objectForKey:@"quantity"] intValue]];
        cell.lblProductName.text=[productDetails objectForKey:@"name"];
        return cell;
    }
    else{
        //ShipRequestConfirmOrdinaryCell *cell =(ShipRequestConfirmOrdinaryCell *) [tableView dequeueReusableCellWithIdentifier:[ShipRequestConfirmOrdinaryCell reuseIdentifier]];
        ShipRequestConfirmOrdinaryCell *cell=nil;
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShipRequestConfirmOrdinaryCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (ShipRequestConfirmOrdinaryCell *)currentObject;
                    break;
                }
            }
            
            if(indexPath.row%2==0){
                cell.contentView.backgroundColor=[UIColor colorWithRed:0.94509 green:0.956862 blue:0.984313 alpha:1];
            }
            else{
                cell.contentView.backgroundColor=[UIColor whiteColor];
            }
            if(indexPath.row==[self.selectedProductsArray count]){
                if([self.termsOFPay isEqualToString:@"skrill"]){
                    cell.lblName.text=@"Willing to transfer money";
                    
                }
                else if ([self.termsOFPay isEqualToString:@"noPay"]){
                    cell.lblName.text=@"Pick up only";
                }
                else if ([self.termsOFPay isEqualToString:@"cod"]){
                    cell.lblName.text=@"Cash on delivery";
                }
                cell.imageHolder.image=[UIImage imageNamed:@"shipping_wallet_icon.png"];
            }
            else if (indexPath.row==[self.selectedProductsArray count]+1){
                cell.lblName.text=[NSString stringWithFormat:@"%@ -> %@",[self.pickPlace objectForKey:@"address"],[self.dropPlace objectForKey:@"address"]];
                cell.imageHolder.image=[UIImage imageNamed:@"shipping_location_icon.png"];
            }
            else if (indexPath.row==[self.selectedProductsArray count]+2){
                if([self.dateOfDelivery isEqualToString:@"rush"]){
                    cell.lblName.text=[NSString stringWithFormat:@"Before: %@",[Common getDateAfterDays:2]];
                }
                else if ([self.dateOfDelivery isEqualToString:@"week"]){
                    cell.lblName.text=[NSString stringWithFormat:@"Before: %@",[Common getDateAfterDays:7]];
                }
                else if ([self.dateOfDelivery isEqualToString:@"anytime"]){
                    cell.lblName.text=[NSString stringWithFormat:@"Before: %@",[Common getDateAfterDays:30]];
                }
                cell.imageHolder.image=[UIImage imageNamed:@"shipping_calendar_icon.png"];
            }
            else if (indexPath.row==[self.selectedProductsArray count]+3){
                cell.lblName.text=[NSString stringWithFormat:@"Earn %@ points",self.karmaPts];
                cell.imageHolder.image=[UIImage imageNamed:@"shipping_earning_pts.png"];
            }
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str=nil;
    if(indexPath.row<[self.selectedProductsArray count]){
        str=[[self.selectedProductsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(218, 999) lineBreakMode:UILineBreakModeWordWrap];
        if((size.height+10)>44){
            return size.height+10;
        }
        else{
            return 44;
        }
    }
    else if (indexPath.row==[self.selectedProductsArray count]+1){
        str=[NSString stringWithFormat:@"%@ -> %@",[self.pickPlace objectForKey:@"address"],[self.dropPlace objectForKey:@"address"]];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(250, 999) lineBreakMode:UILineBreakModeWordWrap];
        if((size.height+10)>44){
            return size.height+10;
        }
        else{
            return 44;
        }
    }
    else{
        return 44;
    }
    
}

#pragma mark MBProgressHUD Delegates

- (void)hudWasHidden:(MBProgressHUD *)hud {// Remove HUD from screen when the HUD was hidded
	[progressHud removeFromSuperview];
	[progressHud release];
	progressHud = nil;
}

#pragma mark -IBAction

- (IBAction)btttnActionPostRequest:(id)sender {
    progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    progressHud.delegate = self;
    [self.view addSubview:progressHud];
    [progressHud show:YES];
    
    NSDictionary *pickUpDict=[NSDictionary dictionaryWithObjectsAndKeys:[self.pickPlace objectForKey:@"lat"],@"latt",[self.pickPlace objectForKey:@"lng"],@"long", nil];
    NSDictionary *dropOffDict=[NSDictionary dictionaryWithObjectsAndKeys:[self.dropPlace objectForKey:@"lat"],@"latt",[self.dropPlace objectForKey:@"lng"],@"long", nil];
    //PFGeoPoint *pickUpGeoPoint = [PFGeoPoint geoPointWithLatitude:[[self.pickPlace objectForKey:@"lat"] doubleValue] longitude:[[self.pickPlace objectForKey:@"lng"] doubleValue]];
    //PFGeoPoint *dropOffGeoPoint = [PFGeoPoint geoPointWithLatitude:[[self.dropPlace objectForKey:@"lat"] doubleValue] longitude:[[self.dropPlace objectForKey:@"lng"] doubleValue]];
    
    PFObject *shipReqObj = [PFObject objectWithClassName:kFSRequestClassKey];
    [shipReqObj setObject:self.selectedProductsArray forKey:kFSRequestItemsKey];
    [shipReqObj setObject:[PFUser currentUser] forKey:kFSRequestFromUserKey];
    [shipReqObj setObject:[self.pickPlace objectForKey:@"address"] forKey:kFSRequestFromStreetKey];
    [shipReqObj setObject:pickUpDict forKey:kFSRequestFromCoordinateKey];
    [shipReqObj setObject:[self.dropPlace objectForKey:@"address"] forKey:kFSRequestToStreetKey];
    [shipReqObj setObject:dropOffDict forKey:kFSRequestToCoordinateKey];
    [shipReqObj setObject:self.termsOFPay forKey:@"paymentTerms"];
    [shipReqObj setObject:self.dateOfDelivery forKey:kFSRequestDeliveryTypeKey];
    [shipReqObj setObject:[NSNumber numberWithInt:[self.karmaPts intValue]] forKey:kFSRequestKarmaKey];
    [shipReqObj setObject:[NSNumber numberWithInt:0] forKey:kFSRequestOffersCountKey];
    [shipReqObj saveInBackgroundWithBlock:^(BOOL succeed,NSError *error){
        if(succeed){
            //NSLog(@"[shipReqObj createdAt]=%@", [shipReqObj objectId]);
            NSDate *createdDate=[shipReqObj createdAt];
            NSDate *expireDate=nil;
            if([[shipReqObj objectForKey:kFSRequestDeliveryTypeKey] isEqualToString:@"rush"]){
                expireDate= [Common addDays:2 toDate:createdDate];
            }
            else if ([[shipReqObj objectForKey:kFSRequestDeliveryTypeKey] isEqualToString:@"week"]){
                expireDate= [Common addDays:7 toDate:createdDate];
            }
            else{
                expireDate= [Common addDays:30 toDate:createdDate];
            }
            [shipReqObj setObject:expireDate forKey:kFSRequestDeliveryDateKey];
            [shipReqObj saveInBackgroundWithBlock:^(BOOL succeeded,NSError *err){
                if(succeeded){
                    [ShippingRequestObject sharedInstance].productsArray=nil;
                    [ShippingRequestObject sharedInstance].pickUpPlace=nil;
                    [ShippingRequestObject sharedInstance].dropOffPlace=nil;
                    [ShippingRequestObject sharedInstance].deliveryDate=nil;
                    [ShippingRequestObject sharedInstance].paymentTerms=nil;
                    [ShippingRequestObject sharedInstance].karmaPoints=nil;
                    [self.navigationController dismissViewControllerAnimated:YES completion:^(){
                        [Common showAlertwithTitle:nil alertString:@"Shipping Request successfully posted" cancelbuttonName:@"OK"];
                    }];
                }
                else{
                    [Common showAlertwithTitle:@"Error Occured" alertString:error.localizedDescription cancelbuttonName:@"OK"];
                }
                [progressHud hide:YES];
            }];
        }
        else{
            [Common showAlertwithTitle:@"Error Occured" alertString:@"Please repost the shipping request" cancelbuttonName:@"OK"];
            [progressHud hide:YES];
        }
    }];
}

-(void)bttnActionClose:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)bttnActionGoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
