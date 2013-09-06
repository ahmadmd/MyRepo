//
//  RequestDetailViewController.m
//  FriendShippr
//
//  Created by Zoondia on 26/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "RequestDetailViewController.h"

@implementation RequestDetailViewController
@synthesize shippingReqObj,userObj,currentPage,nextPage,tableReq,tblHeaderView,lblUserName,profileImgHolder,productImageHolder;

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
    // Do any additional setup after loading the view from its nib.
    
   // NSLog(@"count=%d",[[shippingReqObj objectForKey:@"items"] count]);
    
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
    
    profileImgHolder = [[PFImageView alloc] initWithFrame:CGRectMake( 4.0f, 5.0f, 44.0f, 44.0f)];
    [self.profileImgHolder setContentMode:UIViewContentModeScaleAspectFill];
    self.profileImgHolder.alpha=0.0f;
    [self.tblHeaderView addSubview:self.profileImgHolder];
    
    self.tableReq.tableHeaderView=self.tblHeaderView;
}

-(void)viewWillAppear:(BOOL)animated{
    self.lblUserName.text=[userObj objectForKey:kFSUserDisplayNameKey];
    
    PFFile *imageFile = [userObj objectForKey:kFSUserProfilePicSmallKey];
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
    
    
    NSArray *products=[self.shippingReqObj objectForKey:kFSRequestItemsKey];
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
    
    [self.tableReq reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)dealloc{
    [shippingReqObj release];
    [userObj release];
    [tableReq release];
    [lblUserName release];
    [profileImgHolder release];
    [productImageHolder release];
    [tblHeaderView release];
    [currentPage release];
    [nextPage release];
    [super dealloc];
}

#pragma mark TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.shippingReqObj objectForKey:kFSRequestItemsKey] count]+4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row<[[self.shippingReqObj objectForKey:kFSRequestItemsKey] count]){
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
        NSDictionary *productDetails=(NSDictionary*)[[self.shippingReqObj objectForKey:kFSRequestItemsKey] objectAtIndex:indexPath.row];
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
            if(indexPath.row==[[self.shippingReqObj objectForKey:kFSRequestItemsKey] count]){
                if([[self.shippingReqObj objectForKey:@"paymentTerms"] isEqualToString:@"skrill"]){
                    cell.lblName.text=@"Willing to transfer money";
                    
                }
                else if ([[self.shippingReqObj objectForKey:@"paymentTerms"] isEqualToString:@"noPay"]){
                    cell.lblName.text=@"Pick up only";
                }
                else if ([[self.shippingReqObj objectForKey:@"paymentTerms"] isEqualToString:@"cod"]){
                    cell.lblName.text=@"Cash on delivery";
                }
                cell.imageHolder.image=[UIImage imageNamed:@"shipping_wallet_icon.png"];
            }
            else if (indexPath.row==[[shippingReqObj objectForKey:kFSRequestItemsKey] count]+1){
                cell.lblName.text=[NSString stringWithFormat:@"%@ -> %@",[self.shippingReqObj objectForKey:kFSRequestFromStreetKey],[self.shippingReqObj objectForKey:kFSRequestToStreetKey]];
                cell.imageHolder.image=[UIImage imageNamed:@"shipping_location_icon.png"];
            }
            else if (indexPath.row==[[self.shippingReqObj objectForKey:kFSRequestItemsKey] count]+2){
                if([[self.shippingReqObj objectForKey:kFSRequestDeliveryTypeKey] isEqualToString:@"rush"]){
                    cell.lblName.text=[NSString stringWithFormat:@"Before: %@",[Common getDateAfterDays:2]];
                }
                else if ([[self.shippingReqObj objectForKey:kFSRequestDeliveryTypeKey] isEqualToString:@"week"]){
                    cell.lblName.text=[NSString stringWithFormat:@"Before: %@",[Common getDateAfterDays:7]];
                }
                else if ([[self.shippingReqObj objectForKey:kFSRequestDeliveryTypeKey] isEqualToString:@"anytime"]){
                    cell.lblName.text=[NSString stringWithFormat:@"Before: %@",[Common getDateAfterDays:30]];
                }
                cell.imageHolder.image=[UIImage imageNamed:@"shipping_calendar_icon.png"];
            }
            else if (indexPath.row==[[self.shippingReqObj objectForKey:kFSRequestItemsKey] count]+3){
                cell.lblName.text=[NSString stringWithFormat:@"Earn %@ points",[self.shippingReqObj objectForKey:kFSRequestKarmaKey]];
                cell.imageHolder.image=[UIImage imageNamed:@"shipping_earning_pts.png"];
            }
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str=nil;
    if(indexPath.row<[[self.shippingReqObj objectForKey:kFSRequestItemsKey] count]){
        str=[[[self.shippingReqObj objectForKey:kFSRequestItemsKey] objectAtIndex:indexPath.row] objectForKey:@"name"];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(218, 999) lineBreakMode:UILineBreakModeWordWrap];
        if((size.height+10)>44){
            return size.height+10;
        }
        else{
            return 44;
        }
    }
    else if (indexPath.row==[[self.shippingReqObj objectForKey:kFSRequestItemsKey] count]+1){
        str=[NSString stringWithFormat:@"%@ -> %@",[self.shippingReqObj objectForKey:kFSRequestFromStreetKey],[self.shippingReqObj objectForKey:kFSRequestToStreetKey]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==[[shippingReqObj objectForKey:kFSRequestItemsKey] count]+1){
        NSLog(@"Show travel route detail page");
    }
}



#pragma mark IBActions

-(void)bttnActionGoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bttnActionForward:(id)sender {
    ForwardFriendSelectViewController *friendsSelect=[[ForwardFriendSelectViewController alloc] initWithNibName:@"ForwardFriendSelectViewController" bundle:nil];
    friendsSelect.shippingReqObj=self.shippingReqObj;
    [self.navigationController pushViewController:friendsSelect animated:YES];
    [friendsSelect release];
}

- (IBAction)bttnActionIDoIt:(id)sender {
    progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    progressHud.delegate = self;
    [self.view addSubview:progressHud];
    [progressHud show:YES];
    
    PFObject *offerObj = [PFObject objectWithClassName:kFSOfferClassKey];
    [offerObj setObject:[PFUser currentUser] forKey:kFSOfferFromUserKey];
    [offerObj setObject:self.shippingReqObj forKey:kFSOfferRequestKey];
    [offerObj saveInBackgroundWithBlock:^(BOOL succeed,NSError *error){
        [progressHud hide:YES];
        if(succeed){
            [Common showAlertwithTitle:nil alertString:@"Offer successfully posted" cancelbuttonName:@"OK"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [Common showAlertwithTitle:@"Error Occured" alertString:error.localizedDescription cancelbuttonName:@"OK"];
        }
    }];
}

#pragma mark MBProgressHUD Delegates

- (void)hudWasHidden:(MBProgressHUD *)hud {// Remove HUD from screen when the HUD was hidded
	[progressHud removeFromSuperview];
	[progressHud release];
	progressHud = nil;
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

@end
