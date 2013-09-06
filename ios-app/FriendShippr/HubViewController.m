//
//  HubViewController.m
//  FriendShippr
//
//  Created by Zoondia on 30/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "HubViewController.h"

@implementation HubViewController
@synthesize hubTableController,segmentSelect;

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

-(void)addHubAsChildViewController{
    [self addChildViewController:self.hubTableController];
    self.hubTableController.view.frame = CGRectMake(0.0f, self.segmentSelect.frame.origin.y+self.segmentSelect.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.segmentSelect.frame.size.height);
    [self.view addSubview:self.hubTableController.view];
}

-(void)removeHubAsChildViewController{
    [self.hubTableController.view removeFromSuperview];
    [self.hubTableController removeFromParentViewController];
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"Hub";
    
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
    
    hubTableController = [[HubTableController alloc] initWithStyle:UITableViewStylePlain];
    
    CGRect frame= self.segmentSelect.frame;
    [self.segmentSelect setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 35)];
    
    UIImage *unselectedBackgroundImage = [[UIImage imageNamed:@"segmentUnselected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [[UISegmentedControl appearance] setBackgroundImage:unselectedBackgroundImage
                                               forState:UIControlStateNormal
                                             barMetrics:UIBarMetricsDefault];
    
    /* Selected background */
    UIImage *selectedBackgroundImage = [[UIImage imageNamed:@"segmentSelected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UISegmentedControl appearance] setBackgroundImage:selectedBackgroundImage
                                               forState:UIControlStateSelected
                                             barMetrics:UIBarMetricsDefault];
    
    [self.segmentSelect setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIFont fontWithName:@"HelveticaNeue-Bold" size:14],UITextAttributeFont,
                                                [UIColor blackColor], UITextAttributeTextColor,
                                                [UIColor blackColor], UITextAttributeTextShadowColor,
                                                [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                nil] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    if(hubTableController==nil){
        hubTableController = [[HubTableController alloc] initWithStyle:UITableViewStylePlain];
    }
    [self addHubAsChildViewController];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self removeHubAsChildViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)dealloc{
    [super dealloc];
    [segmentSelect release];
    [hubTableController release];
}


@end
