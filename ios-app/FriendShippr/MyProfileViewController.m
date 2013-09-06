//
//  MyProfileViewController.m
//  FriendShippr
//
//  Created by Zoondia on 28/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController
@synthesize lblDisplayName,lblKarmaValue,lblShipperTitle,profileImageView;

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
    
    self.navigationItem.title=@"My Profile";
    
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
    
    self.lblDisplayName.text=[[PFUser currentUser] objectForKey:kFSUserDisplayNameKey];
}

-(void)viewWillAppear:(BOOL)animated{
    /*[[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:FB_profilepic_url,[[PFUser currentUser] objectForKey:kFSUserFacebookIDKey]]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image,NSData *data, NSError *error,BOOL finished){
        if (image)
        {
            self.profileImageView.image=[image thumbnailImage:207 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationLow];
        }
    }];*/
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[NSString stringWithFormat:FB_profilepic_url,[[PFUser currentUser] objectForKey:kFSUserFacebookIDKey]]] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error,SDImageCacheType cacheType, BOOL finished){
        if (image)
        {
            self.profileImageView.image=[image thumbnailImage:207 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationLow];
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    self.profileImageView.image=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [lblKarmaValue release];
    [lblDisplayName release];
    [lblShipperTitle release];
    [profileImageView release];
    [super dealloc];
}

#pragma mark IBActions

-(IBAction)bttnActionToggleSlide:(id)sender{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)bttnActionBadges:(id)sender {
}

- (IBAction)bttnActionKarma:(id)sender {
}

- (IBAction)bttnActionAccount:(id)sender {
    SettingsViewController *settView=[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:settView animated:YES];
    [settView release];
}

//Show My Friends page..
- (IBAction)bttnActionFriends:(id)sender {
    MyFriendsViewController *myFriends=[[MyFriendsViewController alloc] initWithNibName:@"MyFriendsViewController" bundle:[NSBundle mainBundle]];
    myFriends.isFromMyProfile=YES;
    [self.navigationController pushViewController:myFriends animated:YES];
    [myFriends release];
}

- (IBAction)bttnActionTopCities:(id)sender {
}
@end
