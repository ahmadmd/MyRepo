//
//  ViewController.m
//  FriendShippr
//
//  Created by Zoondia on 15/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize introScroll,pageNumberControl,currentPage,nextPage,bttnFBLogin;

- (void)applyNewIndex:(NSInteger)newIndex pageController:(IntroPageDesign *)pageController
{
	NSInteger pageCount = [[IntroDataSource sharedDataSource] numDataPages:YES];
	BOOL outOfBounds = newIndex >= pageCount || newIndex < 0;
    
	if (!outOfBounds)
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = 0;
		pageFrame.origin.x = self.introScroll.frame.size.width * newIndex;
		pageController.view.frame = pageFrame;
	}
	else
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = self.introScroll.frame.size.height;
		pageController.view.frame = pageFrame;
	}
    
	pageController.pageIndex = newIndex;
}

- (IBAction)bttnActionFBLogin:(id)sender {
    progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    progressHud.delegate = self;
    [self.view addSubview:progressHud];
    [progressHud show:YES];
    ((UIButton *)sender).enabled=NO;
    
    //Setting the facebook read permissions..
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"email"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error.localizedDescription);
                [Common showAlertwithTitle:@"Error" alertString:error.localizedFailureReason cancelbuttonName:@"OK"];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            // Create request for user's Facebook data
            [self updatePFUserDataFromFacebook:YES];
            
        } else {
            NSLog(@"User with facebook logged in!");
            [self updatePFUserDataFromFacebook:NO];
        }
        
    }];
}

-(void)updatePFUserDataFromFacebook:(BOOL)isSignUp{
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            //NSLog(@"userData=%@\n\n\n\n",userData);
            
            if(isSignUp){
                [[PFUser currentUser] setObject:[userData objectForKey:@"email"] forKey:kFSUserEmailKey];
                [[PFUser currentUser] setObject:[userData objectForKey:@"id"] forKey:kFSUserFacebookIDKey];
                PFACL *defaultACL = [PFACL ACL];
                [defaultACL setPublicReadAccess:YES];
                [PFUser currentUser].ACL = defaultACL;
            }
            if(![[[PFUser currentUser] objectForKey:kFSUserDisplayNameKey] isEqualToString:[userData objectForKey:@"name"]]){
                [[PFUser currentUser] setObject:[userData objectForKey:@"name"] forKey:kFSUserDisplayNameKey];
            }
            if(![[[PFUser currentUser] username] isEqualToString:[userData objectForKey:@"username"]]){
                [[PFUser currentUser] setUsername:[userData objectForKey:@"username"]];
            }
            
            if (([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])){
                //To get the friends list of the currently logged in user..
                [[PFUser currentUser] refreshInBackgroundWithTarget:SharedAppDelegate selector:@selector(refreshCurrentUserCallbackWithResult:error:)];
            }
            
            //updating the PFuser object..
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeed,NSError *err){
                if(!succeed){
                    NSLog(@"error occured in adding user detail=%@",err.localizedDescription);
                }
                else{
                    //Dismissing the login page..
                    [self dismissModalViewControllerAnimated:YES];
                }
                [progressHud hide:YES];
                self.bttnFBLogin.enabled=YES;
            }];
        }
    }];
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentPage = [[IntroPageDesign alloc] initWithNibName:@"IntroPageDesign" bundle:nil];
	nextPage = [[IntroPageDesign alloc] initWithNibName:@"IntroPageDesign" bundle:nil];
	[self.introScroll addSubview:currentPage.view];
	[self.introScroll addSubview:nextPage.view];
    
	NSInteger widthCount = [[IntroDataSource sharedDataSource] numDataPages:YES];
	if (widthCount == 0)
	{
		widthCount = 1;
	}
	
    self.introScroll.contentSize =
    CGSizeMake(
               self.introScroll.frame.size.width * widthCount,
               self.introScroll.frame.size.height);
	self.introScroll.contentOffset = CGPointMake(0, 0);
    
	self.pageNumberControl.numberOfPages = [[IntroDataSource sharedDataSource] numDataPages:YES];
	self.pageNumberControl.currentPage = 0;
	
	[self applyNewIndex:0 pageController:currentPage];
	[self applyNewIndex:1 pageController:nextPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)dealloc{
    [bttnFBLogin release];
    [super dealloc];
    [introScroll release];
    [pageNumberControl release];
    [currentPage release];
    [nextPage release];
}



#pragma mark MBProgressHUD Delegates

// Remove HUD from screen when the HUD was hidded
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[progressHud removeFromSuperview];
	[progressHud release];
	progressHud = nil;
}

#pragma mark UIScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.introScroll.frame.size.width;
    float fractionalPage = self.introScroll.contentOffset.x / pageWidth;
	
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

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView
{
    CGFloat pageWidth = self.introScroll.frame.size.width;
    float fractionalPage = self.introScroll.contentOffset.x / pageWidth;
	NSInteger nearestNumber = lround(fractionalPage);
    
	if (currentPage.pageIndex != nearestNumber)
	{
		IntroPageDesign *swapController = currentPage;
		currentPage = nextPage;
		nextPage = swapController;
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
	[self scrollViewDidEndScrollingAnimation:newScrollView];
	self.pageNumberControl.currentPage = currentPage.pageIndex;
}


@end
