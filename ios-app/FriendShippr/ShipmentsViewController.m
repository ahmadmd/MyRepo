//
//  ShipmentsViewController.m
//  FriendShippr
//
//  Created by Zoondia on 06/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "ShipmentsViewController.h"

@interface ShipmentsViewController ()

@end

@implementation ShipmentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"Shipments";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
