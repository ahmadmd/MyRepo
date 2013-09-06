//
//  AppDelegate.m
//  FriendShippr
//
//  Created by Zoondia on 15/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "IIViewDeckController.h"
#import "Flurry.h"
#import <NewRelicAgent/NewRelicAgent.h>
#import "Crittercism.h"

@interface AppDelegate(){
    
}

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;

@end

@implementation AppDelegate
@synthesize viewController,deckController,homeNavigation,hubNavigation,shipmentsNavigation,storeNavigation,routesNavigation,myProfileNavigation;
@synthesize networkStatus;

- (void)dealloc
{
    [_window release];
    [viewController release];
    [deckController release];
    [homeNavigation release];
    [hubNavigation release];
    [myProfileNavigation release];
    [shipmentsNavigation release];
    [storeNavigation release];
    [routesNavigation release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [NewRelicAgent startWithApplicationToken:@"AA8312191320de442197a3438d10a374e6ed4dcb89"];
    [Flurry startSession:Flurry_API_key];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                UITextAttributeTextColor: [UIColor whiteColor],
                                     UITextAttributeFont: [UIFont fontWithName:@"Cantarell" size:18],
     }];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"blue_nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [Common sharedInstance].slideMenuSelected=0;
    
    //parse initialization..
    [Parse setApplicationId:Parse_Application_ID clientKey:Parse_Client_Key];
    [PFFacebookUtils initializeFacebook];
    
    // Use Reachability to monitor connectivity
    [self monitorReachability];
    
    //to upload the no product image into parse so that its url can be saved for later use..
    [self uploadAndSaveNoProductUrl];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    SlideLeftViewController *slideView=[[SlideLeftViewController alloc] initWithNibName:@"SlideLeftViewController" bundle:[NSBundle mainBundle]];
    
    HomeViewController *homeView=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    // Check if a user is cached && Check if user is linked to Facebook
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        homeView.isFirstLoad=NO;
    }
    else{
        homeView.isFirstLoad=YES;
    }
    homeNavigation=[[UINavigationController alloc] initWithRootViewController:homeView];
    
    MyProfileViewController *myProfileView=[[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:[NSBundle mainBundle]];
    myProfileNavigation=[[UINavigationController alloc] initWithRootViewController:myProfileView];
    
    HubViewController *hubView=[[HubViewController alloc] initWithNibName:@"HubViewController" bundle:[NSBundle mainBundle]];
    hubNavigation=[[UINavigationController alloc] initWithRootViewController:hubView];
    
    ShipmentsViewController *shipmentView=[[ShipmentsViewController alloc] initWithNibName:@"ShipmentsViewController" bundle:[NSBundle mainBundle]];
    shipmentsNavigation=[[UINavigationController alloc] initWithRootViewController:shipmentView];
    
    RoutesViewController *routeView=[[RoutesViewController alloc] initWithNibName:@"RoutesViewController" bundle:[NSBundle mainBundle]];
    routesNavigation=[[UINavigationController alloc] initWithRootViewController:routeView];
    
    StoreViewController *storeView=[[StoreViewController alloc] initWithNibName:@"StoreViewController" bundle:[NSBundle mainBundle]];
    storeNavigation=[[UINavigationController alloc] initWithRootViewController:storeView];
    
    
    viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.homeNavigation leftViewController:slideView rightViewController:nil];
    self.deckController.leftSize=206;
    self.deckController.shadowEnabled=NO;
    
    //setting the ViewDeck as the rootViewController..
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    
    //Present the login page if no cached user found..
    if (!([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])){
        [self.deckController presentModalViewController:self.viewController animated:NO];
    }
    [slideView release];
    [homeView release];
    
    [Crittercism enableWithAppID: @"5219d4744002053230000002"];
    
    return YES;
}

-(void)uploadAndSaveNoProductUrl{
    if(![[NSUserDefaults standardUserDefaults] objectForKey:kFSNoProductImageUrlKey]){
        NSData *noProductImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"NoProduct.png"], 0.5);
        if (noProductImageData.length > 0) {
            NSLog(@"Uploading No Product Picture");
            PFFile *fileImage = [PFFile fileWithData:noProductImageData];
            [fileImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Uploaded No Product Picture url=%@",fileImage.url);
                    [[NSUserDefaults standardUserDefaults] setObject:fileImage.url forKey:kFSNoProductImageUrlKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else{
                    NSLog(@"Error occured in uploading No Product Picture");
                }
            }];
        }
    }
}

- (void)monitorReachability {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostName: @"api.parse.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

//Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note {
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NSLog(@"Reachability changed: %@", curReach);
    networkStatus = [curReach currentReachabilityStatus];
    
    //if ([self isParseReachable] && [PFUser currentUser] && self.homeViewController.objects.count == 0) {
    // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
    // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
    // [self.homeViewController loadObjects];
    // }
}

//To check whether parse is reachable..
- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

//logging out the current logged in PFUser and showing the login page..
- (void) logoutUser{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    [PFUser logOut];
    [self.deckController closeLeftViewAnimated:YES];
    [self.deckController presentModalViewController:self.viewController animated:NO];
}

- (void)refreshCurrentUserCallbackWithResult:(PFObject *)refreshedObject error:(NSError *)error {
    // A kPFErrorObjectNotFound error on currentUser refresh signals a deleted user
    if (error && error.code == kPFErrorObjectNotFound) {
        NSLog(@"User does not exist.");
        [SharedAppDelegate logoutUser];
        return;
    }
    // Check if user is missing a Facebook ID
    if ([Common userHasValidFacebookData:[PFUser currentUser]]) {
        // User has Facebook ID.
        
        // refresh Facebook friends on each launch
        FBRequest *request = [FBRequest requestForMyFriends];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            //NSLog(@"requestForMyFriends result=%@",result);
            if (!error) {
                // result will contain an array with your user's friends in the "data" key
                NSArray *friendObjects = [result objectForKey:@"data"];
                NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
                // Create a list of friends' Facebook IDs
                for (NSDictionary *friendObject in friendObjects) {
                    [friendIds addObject:[friendObject objectForKey:@"id"]];
                }
                
                // Construct a PFUser query that will find friends whose facebook ids are contained in the current user's friend list also update the role table
                PFQuery *friendQuery = [PFUser query];
                [friendQuery whereKey:kFSUserFacebookIDKey containedIn:friendIds];
                [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        PFRole *role=[[PFUser currentUser] objectForKey:kFSUserRoleKey];
                        NSLog(@"Successfully retrieved %d friends.", objects.count);
                        NSMutableArray *tempArr=[[NSMutableArray alloc] init];
                        for (PFUser *user in objects) {
                            [role.users addObject:user];
                            [tempArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[user objectForKey:kFSUserFacebookIDKey],@"id",[user objectForKey:kFSUserDisplayNameKey],@"name", nil]];
                        }
                        [role saveInBackgroundWithBlock:^(BOOL succeeded,NSError *err){
                            if(!succeeded){
                                NSLog(@"errror=%@",err.localizedDescription);
                                [Common showAlertwithTitle:@"Error" alertString:[error localizedDescription] cancelbuttonName:@"OK"];
                            }
                            NSLog(@"friendsUpdatedNotification posted");
                            [[NSNotificationCenter defaultCenter] postNotificationName:FSFriendsUpdatedNotification object:nil];
                        }];
                        [Common sharedInstance].parseFriends=tempArr;
                        [tempArr release];
                        
                       
                    }
                    else {
                         NSLog(@"friendsUpdatedNotification posted");
                        [[NSNotificationCenter defaultCenter] postNotificationName:FSFriendsUpdatedNotification object:nil];
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                        [Common showAlertwithTitle:@"Error" alertString:[error localizedDescription] cancelbuttonName:@"OK"];
                    }
                    
                }];
            }
        }];
        
        NSLog(@"Downloading user's profile picture");
        // Download user's profile picture
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kFSUserFacebookIDKey]]];
        NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
        [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
        
    } else {
        NSLog(@"User missing Facebook ID");
    }
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [Common processFacebookProfilePictureData:_data];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

@end
