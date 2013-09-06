//
//  PopoverViewController.m
//  FriendShippr
//
//  Created by Zoondia on 19/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "PopoverViewController.h"

@interface PopoverViewController ()

@end

@implementation PopoverViewController
@synthesize bttnShipReq,bttnTravelRoute;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contentSizeForViewInPopover=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bttnShipReq.titleLabel.font=[UIFont fontWithName:@"Cantarell-Bold" size:16];
    self.bttnTravelRoute.titleLabel.font=[UIFont fontWithName:@"Cantarell-Bold" size:16];
}

-(void)dealloc{
    [bttnShipReq release];
    [bttnTravelRoute release];
    [super dealloc];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (IBAction)bttnActionShippingRequest:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:FSShippingRquestClickedNotification object:nil];
}

- (IBAction)bttnActionTravelRoute:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTravelRouteClickedNotification object:nil];
}


@end
