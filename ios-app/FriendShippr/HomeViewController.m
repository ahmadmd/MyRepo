//
//  HomeViewController.m
//  FriendShippr
//
//  Created by Zoondia on 15/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize isFirstLoad,userfriends;
@synthesize popoverController,bgImageHolder,tutorialHolder,txtFirstTutorialView,txtSecondTutorialView,feedsTableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)bttnActionToggleSlide:(id)sender{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

//popover menu..
-(void)presentCustomPopOver{
    UIViewController *contentViewController = [[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:[NSBundle mainBundle]];
    
    self.popoverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
    self.popoverController.delegate=self;
    [self.popoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [contentViewController release];
}

//show the invite friends modal..
- (IBAction)bttnActionFriends:(id)sender {
    MyFriendsViewController *myFriends=[[MyFriendsViewController alloc] initWithNibName:@"MyFriendsViewController" bundle:[NSBundle mainBundle]];
    myFriends.isFromMyProfile=NO;
    UINavigationController *myFriendsNav=[[UINavigationController alloc] initWithRootViewController:myFriends];
    [self presentModalViewController:myFriendsNav animated:YES];
    [myFriends release];
    [myFriendsNav release];
}

-(void)addFeedsAsChildViewController{
    [self addChildViewController:self.feedsTableViewController];
    self.feedsTableViewController.view.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:self.feedsTableViewController.view];
}

-(void)removeFeedsAsChildViewController{
    [self.feedsTableViewController.view removeFromSuperview];
    [self.feedsTableViewController removeFromParentViewController];
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.txtFirstTutorialView.font=[UIFont fontWithName:@"Cantarell-Bold" size:19];
    self.txtSecondTutorialView.font=[UIFont fontWithName:@"Cantarell-Bold" size:19];
    
    if (([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])){
        NSLog(@"called refresh friends list");
        [[PFUser currentUser] refreshInBackgroundWithTarget:SharedAppDelegate selector:@selector(refreshCurrentUserCallbackWithResult:error:)];
    }
    
    UIImage *leftimage = [UIImage imageNamed:@"slideMenuButton.png"];
    CGRect frameimg = CGRectMake(0, 0, 22, 20);
    UIButton *leftButton = [[UIButton alloc] initWithFrame:frameimg];
    [leftButton setBackgroundImage:leftimage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(bttnActionToggleSlide:)
         forControlEvents:UIControlEventTouchUpInside];
    [leftButton setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *leftBarbutton =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=leftBarbutton;
    [leftButton release];
    [leftBarbutton release];
    
    UIImage* rightImage = [UIImage imageNamed:@"nav_bar_btn.png"];
    CGRect rightImageframe = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
    UIButton *rightButton = [[UIButton alloc] initWithFrame:rightImageframe];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(presentCustomPopOver)
          forControlEvents:UIControlEventTouchUpInside];
    [rightButton setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *rightBarbutton =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightBarbutton;
    [rightButton release];
    [rightBarbutton release];
    
    UIImageView *titleImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_bar_logo_icon.png"]];
    titleImageView.frame=CGRectMake(0, 0, 19, 36);
    self.navigationItem.titleView=titleImageView;
    [titleImageView release];
    
    
    if (([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])){
        PFRole *role=[[PFUser currentUser] objectForKey:kFSUserRoleKey];
        PFRelation *friendsRelation=role.users;
        PFQuery *query = [friendsRelation query];
        //to get the parse friends from Role..
        [query findObjectsInBackgroundWithBlock:^(NSArray *friends,NSError *error){
            if([friends count]<=0){
                CGRect frame=self.tutorialHolder.frame;
                frame.size.height=self.view.frame.size.height;
                self.tutorialHolder.frame=frame;
                [self.view addSubview:self.tutorialHolder];
            }
            else{
                feedsTableViewController = [[FeedsTableController alloc] initWithStyle:UITableViewStylePlain];
                userfriends=[[NSArray alloc] init];
                self.feedsTableViewController.friendsArray=friends;
                self.userfriends=friends;
                [self addFeedsAsChildViewController];
            }
        }];
    }
    else{
        progressHud = [[MBProgressHUD alloc] initWithView:self.view];
        progressHud.delegate = self;
        progressHud.labelText=@"Loading Data";
        [self.view addSubview:progressHud];
        [progressHud show:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if([self.userfriends count]>0 && self.userfriends!=nil){
        [self addFeedsAsChildViewController];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shippingRequestNotifRecieved:) name:FSShippingRquestClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(travelRouteNotifRecieved:) name:FSTravelRouteClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendsUpdatedNotifRecieved:) name:FSFriendsUpdatedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FSShippingRquestClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FSTravelRouteClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FSFriendsUpdatedNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    if([self.userfriends count]>0 && self.userfriends!=nil){
        [self removeFeedsAsChildViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)dealloc{
    [bgImageHolder release];
    [tutorialHolder release];
    [txtFirstTutorialView release];
    [txtSecondTutorialView release];
    [feedsTableViewController release];
    [userfriends release];
    [super dealloc];
}


#pragma mark MBProgressHUD Delegates

// Remove HUD from screen when the HUD was hidded
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[progressHud removeFromSuperview];
	[progressHud release];
	progressHud = nil;
}

#pragma mark NSNotification Functions

//update feeds after friends list updated..
- (void) friendsUpdatedNotifRecieved:(NSNotification*) notification {
    [progressHud hide:YES];
    if([self.childViewControllers count]>0){
        [self.feedsTableViewController loadObjects];
    }
    else{
        PFRole *role=[[PFUser currentUser] objectForKey:kFSUserRoleKey];
        PFRelation *friendsRelation=role.users;
        PFQuery *query = [friendsRelation query];
        //to get the parse friends from Role..
        [query findObjectsInBackgroundWithBlock:^(NSArray *friends,NSError *error){
            if([friends count]<=0){
                CGRect frame=self.tutorialHolder.frame;
                frame.size.height=self.view.frame.size.height;
                self.tutorialHolder.frame=frame;
                [self.view addSubview:self.tutorialHolder];
            }
            else{
                feedsTableViewController = [[FeedsTableController alloc] initWithStyle:UITableViewStylePlain];
                self.feedsTableViewController.friendsArray=friends;
                [self addChildViewController:self.feedsTableViewController];
                self.feedsTableViewController.view.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
                [self.view addSubview:self.feedsTableViewController.view];
            }
        }];
    }
}

//show shipping request modal..
- (void) shippingRequestNotifRecieved:(NSNotification*) notification {
    [self.popoverController dismissPopoverAnimated:YES];
    
    ProductEntryViewController *productEntry=[[ProductEntryViewController alloc] initWithNibName:@"ProductEntryViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *shippingFlowNav=[[UINavigationController alloc] initWithRootViewController:productEntry];
    [self presentModalViewController:shippingFlowNav animated:YES];
    [productEntry release];
    [shippingFlowNav release];
}

//show travel route modal..
- (void) travelRouteNotifRecieved:(NSNotification*) notification {
    [self.popoverController dismissPopoverAnimated:YES];
    
    PickUpPointViewController *pickupEntry=[[PickUpPointViewController alloc] initWithNibName:@"PickUpPointViewController" bundle:[NSBundle mainBundle]];
    pickupEntry.isFromShippingReq=NO;
    UINavigationController *travelFlowNav=[[UINavigationController alloc] initWithRootViewController:pickupEntry];
    [self presentModalViewController:travelFlowNav animated:YES];
    [pickupEntry release];
    [travelFlowNav release];
}

#pragma mark WEPopoverController Delegates

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController1{
    self.popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController{
    return YES;
}


@end
