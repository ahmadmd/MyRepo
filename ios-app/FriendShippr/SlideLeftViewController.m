//
//  SlideLeftViewController.m
//  FriendShippr
//
//  Created by Zoondia on 16/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "SlideLeftViewController.h"
#import "AppDelegate.h"

@interface SlideLeftViewController ()

@end

@implementation SlideLeftViewController
@synthesize sideMenuTable,menuListArray,tblHeaderView,profileImgHolder,tblFooterView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)bttnActionLogout:(id)sender {
    //Logout..
    [SharedAppDelegate logoutUser];
}

-(IBAction)bttnActionProfile:(id)sender{
    [Common sharedInstance].slideMenuSelected=FSProfileViewControllerIndex;
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        self.viewDeckController.centerController=SharedAppDelegate.myProfileNavigation;
    }];
    [self.sideMenuTable reloadData];
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    //ImageName and menu title for the slide menu..
    menuListArray=[[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Feed",@"name",@"rectangle_icon.png",@"imageName", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"Hub",@"name",@"rectangle_icon.png",@"imageName", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"Shipments",@"name",@"rectangle_icon.png",@"imageName", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"Routes",@"name",@"rectangle_icon.png",@"imageName", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"Store",@"name",@"rectangle_icon.png",@"imageName", nil], nil];
    
    //profile pic holder..
    profileImgHolder = [[PFImageView alloc] initWithFrame:CGRectMake( 27.0f, 6.0f, 60.0f, 60.0f)];
    [self.profileImgHolder setContentMode:UIViewContentModeScaleAspectFill];
    self.profileImgHolder.alpha=0.0f;
    [self.tblHeaderView addSubview:self.profileImgHolder];
    
    UIButton *bttnProfile=[[UIButton alloc] initWithFrame:CGRectMake( 27.0f, 6.0f, 60.0f, 60.0f)];
    [bttnProfile addTarget:self action:@selector(bttnActionProfile:) forControlEvents:UIControlEventTouchUpInside];
    [self.tblHeaderView addSubview:bttnProfile];
    
    //header and footer for the table...
    self.sideMenuTable.tableHeaderView=self.tblHeaderView;
    self.sideMenuTable.tableFooterView=self.tblFooterView;
}

-(void)viewWillAppear:(BOOL)animated{
    //setting the rounded profile pic..
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}


- (void)dealloc {
    [sideMenuTable release];
    [menuListArray release];
    [tblHeaderView release];
    [profileImgHolder release];
    [tblFooterView release];
    [super dealloc];
}

#pragma mark TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menuListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SlideCustomCell *cell =nil;
    //(DeliveryDateCell *) [tableView dequeueReusableCellWithIdentifier:[DeliveryDateCell reuseIdentifier]];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SlideCustomCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (SlideCustomCell *)currentObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                break;
            }
        }
    }
    if([Common sharedInstance].slideMenuSelected==indexPath.row){
        cell.bgView.hidden=YES;
    }
    cell.name.text=[[self.menuListArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //loading th main view based on the menu selected..
    if(indexPath.row==FSFeedsViewControllerIndex){
        [Common sharedInstance].slideMenuSelected=FSFeedsViewControllerIndex;
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            self.viewDeckController.centerController=SharedAppDelegate.homeNavigation;
        }];
    }
    else if(indexPath.row==FSHubViewControllerIndex){
        [Common sharedInstance].slideMenuSelected=FSHubViewControllerIndex;
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            self.viewDeckController.centerController=SharedAppDelegate.hubNavigation;
        }];
    }
    else if(indexPath.row==FSShipmentsViewControllerIndex){
        [Common sharedInstance].slideMenuSelected=FSShipmentsViewControllerIndex;
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            self.viewDeckController.centerController=SharedAppDelegate.shipmentsNavigation;
        }];
    }
    else if(indexPath.row==FSRoutesViewControllerIndex){
        [Common sharedInstance].slideMenuSelected=FSRoutesViewControllerIndex;
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            self.viewDeckController.centerController=SharedAppDelegate.routesNavigation;
        }];
    }
    else if(indexPath.row==FSStoreViewControllerIndex){
        [Common sharedInstance].slideMenuSelected=FSStoreViewControllerIndex;
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            self.viewDeckController.centerController=SharedAppDelegate.storeNavigation;
        }];
    }
    [self.sideMenuTable reloadData];
}


@end
