//
//  KarmaPointsViewController.m
//  FriendShippr
//
//  Created by Zoondia on 29/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "KarmaPointsViewController.h"

@interface KarmaPointsViewController ()

@end

@implementation KarmaPointsViewController
@synthesize lblAvailableKarma,txtSelectKarma;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
}

-(void)viewWillAppear:(BOOL)animated{
    if([ShippingRequestObject sharedInstance].karmaPoints!=nil){
        self.txtSelectKarma.text=[ShippingRequestObject sharedInstance].karmaPoints;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [lblAvailableKarma release];
    [txtSelectKarma release];
    [super dealloc];
}

#pragma mark -IBActions

- (IBAction)bttnActionDecreaseKarma:(id)sender {
    int karmaPoint=[txtSelectKarma.text intValue];
    if(karmaPoint>5){
        karmaPoint=karmaPoint-5;
        txtSelectKarma.text=[NSString stringWithFormat:@"%d",karmaPoint];
    }
}

- (IBAction)bttnActionIncreaseKarma:(id)sender {
    int karmaPoint=[txtSelectKarma.text intValue];
    karmaPoint=karmaPoint+5;
    self.txtSelectKarma.text=[NSString stringWithFormat:@"%d",karmaPoint];
}

- (IBAction)bttnActionBuyMoreKarma:(id)sender {
    //Implement in-app purchase....
    [Common showAlertwithTitle:@"Coming Soon" alertString:@"In-App Purchase to be implemented" cancelbuttonName:@"OK"];
}

- (IBAction)bttnActionForward:(id)sender {
    RequestConfirmViewController *requestConfirmView=[[RequestConfirmViewController alloc] initWithNibName:@"RequestConfirmViewController" bundle:[NSBundle mainBundle]];
    [ShippingRequestObject sharedInstance].karmaPoints=self.txtSelectKarma.text;
    [self.navigationController pushViewController:requestConfirmView animated:YES];
    [requestConfirmView release];
}

-(void)bttnActionClose:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)bttnActionGoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
